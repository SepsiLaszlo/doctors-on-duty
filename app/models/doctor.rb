class Doctor < ApplicationRecord
  MIN_DOCTORS_ON_DUTY = 1

  scope :on_duty, -> { where(on_duty: true) }

  def check_in!
    update!(on_duty: true)
  end

  def check_out!
    Doctor.transaction(isolation: :serializable) do
      unless Doctor.on_duty.count - 1 >= MIN_DOCTORS_ON_DUTY
        raise "At least #{MIN_DOCTORS_ON_DUTY} doctor(s) must be on duty"
      end

      update!(on_duty: false)
    end
  end
end
