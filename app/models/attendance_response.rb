class AttendanceResponse
  include ActiveModel::Model
  attr_accessor :study_price, :drink_price, :user

  def attendance
    {
        status: :attendance,
        study_price: study_price,
        drink_price: drink_price,
        user: user
    }
end

  def self.need_user_id
    {status: :need_user_id}
  end
end