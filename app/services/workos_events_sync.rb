class WorkosEventsSync
  EVENT_TYPES = %w[
    dsync.user.created
    dsync.user.updated
    dsync.user.deleted
  ].freeze

  def initialize(organization_id:)
    @organization_id = organization_id
  end

  def call
    return if @organization_id.blank?

    cursor = WorkosEventCursor.find_by(organization_id: @organization_id)
    if cursor.nil? || cursor.last_event_id.blank?
      initial_directory_sync
      cursor ||= WorkosEventCursor.create!(organization_id: @organization_id)
    end

    after = cursor.last_event_id

    loop do
      list = WorkOS::Events.list_events(events: EVENT_TYPES,
                                        organization_id: @organization_id,
                                        limit: 100,
                                        after: after)
      events = list.data
      break if events.empty?

      events.each do |event|
        handle_event(event)
        cursor.update!(last_event_id: event.id)
      end

      after = list.list_metadata['after']
      break if after.blank?
    end
  end

  private

  def initial_directory_sync
    after = nil

    loop do
      list = WorkOS::DirectorySync.list_directories(organization_id: @organization_id,
                                                    limit: 100,
                                                    after: after)
      directories = list.data
      break if directories.empty?

      directories.each do |directory|
        sync_directory_users(directory.id)
      end

      after = list.list_metadata['after']
      break if after.blank?
    end
  end

  def sync_directory_users(directory_id)
    after = nil

    loop do
      list = WorkOS::DirectorySync.list_users(directory: directory_id,
                                              limit: 100,
                                              after: after)
      users = list.data
      break if users.empty?

      users.each do |directory_user|
        upsert_directory_user(directory_user)
      end

      after = list.list_metadata['after']
      break if after.blank?
    end
  end

  def upsert_directory_user(directory_user)
    data = directory_user.to_json
    if data[:state] == 'inactive'
      user = User.find_by(directory_user_id: data[:id]) || User.find_by(email: extract_email(data))
      user&.destroy
      return
    end

    handle_user_created(data)
  end

  def handle_event(event)
    case event.event
    when 'dsync.user.created'
      handle_user_created(event.data)
    when 'dsync.user.updated'
      handle_user_updated(event.data)
    when 'dsync.user.deleted'
      handle_user_deleted(event.data)
    end
  end

  def handle_user_created(data)
    attrs = directory_user_attributes(data)
    user = User.find_by(directory_user_id: data[:id]) || User.find_by(email: attrs[:email])

    if user
      user.update(attrs)
    else
      User.create(attrs.merge(workos_id: data[:id]))
    end
  end

  def handle_user_updated(data)
    attrs = directory_user_attributes(data)
    user = User.find_by(directory_user_id: data[:id]) || User.find_by(email: attrs[:email])
    return unless user

    if data[:state] == 'inactive'
      user.destroy
      return
    end

    user.update(attrs)
  end

  def handle_user_deleted(data)
    user = User.find_by(directory_user_id: data[:id])
    user&.destroy
  end

  def directory_user_attributes(data)
    {
      directory_user_id: data[:id],
      directory_id: data[:directory_id],
      directory_state: data[:state],
      team: extract_team(data),
      email: extract_email(data),
      first_name: data[:first_name],
      last_name: data[:last_name]
    }.compact
  end

  def extract_team(data)
    custom_attributes = data[:custom_attributes] || {}
    custom_attributes[:department_name] || custom_attributes['department_name']
  end

  def extract_email(data)
    email = data[:email]
    return email if email.present?

    emails = data[:emails] || []
    primary = emails.find { |item| item[:primary] }
    email_value = (primary || emails.first || {})[:value]
    return email_value if email_value.present?

    data[:username]
  end
end
