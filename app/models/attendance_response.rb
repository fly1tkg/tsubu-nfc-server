class AttendanceResponse
  include ActiveModel::Model

  def self.attendance
    {
        status: :attendance
    }
  end

  def self.need_user_id
    {status: :need_user_id}
  end
end