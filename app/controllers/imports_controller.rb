class ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    unless params[:file].present?
      redirect_to new_import_path, alert: t('flash.export_file_missing') and return
    end

    begin
      file_content = params[:file].read
      import_data = JSON.parse(file_content)

      # Validate data structure
      unless import_data.is_a?(Hash) && import_data['migraines'].is_a?(Array)
        redirect_to new_import_path, alert: t('flash.import_invalid_json') and return
      end

      # Validate user email if present
      if import_data['user_email'].present? && import_data['user_email'] != current_user.email
        redirect_to new_import_path, alert: t('flash.import_wrong_user', email: import_data['user_email']) and return
      end

      imported_counts = { medications: 0, migraines: 0 }

      ActiveRecord::Base.transaction do
        # Import medications first (to get IDs for migraines)
        medication_mapping = {}
        
        if import_data['medications'].present?
          import_data['medications'].each do |med_data|
            # Find or create medication by name
            medication = current_user.medications.find_or_create_by(name: med_data['name'])
            medication_mapping[med_data['name']] = medication
            imported_counts[:medications] += 1 unless medication.previously_new_record? == false
          end
        end

        # Import migraines
        if import_data['migraines'].present?
          import_data['migraines'].each do |migraine_data|
            # Skip if migraine already exists for this date
            occurred_on = Date.parse(migraine_data['occurred_on'])
            next if current_user.migraines.exists?(occurred_on: occurred_on)

            medication = medication_mapping[migraine_data['medication_name']] if migraine_data['medication_name']

            current_user.migraines.create!(
              occurred_on: occurred_on,
              nature: migraine_data['nature'],
              intensity: migraine_data['intensity'],
              on_period: migraine_data['on_period'],
              medication: medication
            )
            imported_counts[:migraines] += 1
          end
        end
      end

      redirect_to edit_user_registration_path, 
        notice: t('flash.import_success', medications: imported_counts[:medications], migraines: imported_counts[:migraines])
    rescue JSON::ParserError
      redirect_to new_import_path, alert: t('flash.import_invalid_json')
    rescue => e
      redirect_to new_import_path, alert: t('flash.import_error', error: e.message)
    end
  end
end
