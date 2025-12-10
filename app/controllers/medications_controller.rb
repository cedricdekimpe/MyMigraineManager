class MedicationsController < ApplicationController
  def create
    medication = current_user.medications.new(medication_params)

    if medication.save
      redirect_to edit_user_registration_path, notice: "Medication added."
    else
      redirect_to edit_user_registration_path, alert: medication.errors.full_messages.to_sentence
    end
  end

  def destroy
    medication = current_user.medications.find(params[:id])

    if medication.destroy
      redirect_to edit_user_registration_path, notice: "Medication removed."
    else
      redirect_to edit_user_registration_path, alert: "Medication could not be removed."
    end
  end

  private

  def medication_params
    params.require(:medication).permit(:name)
  end
end
