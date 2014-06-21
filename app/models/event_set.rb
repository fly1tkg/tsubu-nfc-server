class EventSet < ActiveRecord::Base
  has_many :events
  serialize :attendance_users, Array

  def self.create_or_update_by_zusaar(id_study, price_study, id_drink, price_drink)
    event_set = joins(:events).find_by(events: {zusaar_id: id_study, kind: :study}) || create
    event_set.events.create_or_update_by_zusaar(id_study, :study, price_study)
    event_set.events.create_or_update_by_zusaar(id_drink, :drink, price_drink)
    event_set
  end

  def study
    @study ||= events.find_by(kind: :study)
  end

  def drink
    @drink ||= events.find_by(kind: :drink)
  end

  def study_title
    study.nil? || study.title
  end

  def study_price
    study.nil? || study.price
  end

  def study_started_at
    study.nil? || study.started_at
  end

  def study_ended_at
    study.nil? || study.ended_at
  end

  def drink_title
    drink.nil? || drink.title
  end

  def drink_price
    drink.nil? || drink.price
  end

  def drink_started_at
    drink.nil? || drink.started_at
  end

  def drink_ended_at
    drink.nil? || drink.ended_at
  end

  def register_users
    # 勉強会と懇親会の登録者のidを取得する
    users_id = []
    if study_event = events.find_by(kind: :study)
      users_id = users_id | study_event.register_users
    end

    if drink_event = events.find_by(kind: :drink)
      users_id = users_id | drink_event.register_users
    end

    # 登録者を取得する
    users = User.where(id: users_id)

    # 出席かどうか
    users.each do |user|
      user.status = attendance_users.include?(user.id) ? :attendance : :registered
    end

    users.as_json(methods: :status)
  end

  def add_attendance_user(user_id)
    self.attendance_users |= [user_id]
    save
  end

  def as_default_json
    as_json(methods: [
        :study_title, :study_price, :study_start_at, :study_ended_at,
        :drink_title, :drink_price, :drink_started_at, :drink_ended_at,
        :register_users
    ])
  end
end
