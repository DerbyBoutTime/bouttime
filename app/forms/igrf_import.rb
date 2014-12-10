class IgrfImport
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :form, String

  validates :form, presence: true
  validate :not_imported

  def igrf
    @igrf ||= InterleagueGameReportingForm.new(form: form)
  end

  def persisted?
    false
  end

  def save
    valid? && persist!
  end

  private

  def not_imported
    errors.add(:form, "Game already imported.") if form && importer.imported?
  end

  def importer
    @importer ||= IgrfImporter::Game.new(Igrf.for(igrf.form.file.file))
  end

  def persist!
    begin
      ActiveRecord::Base.transaction do
        igrf.game = importer.import
        igrf.save!
      end
    rescue ActiveRecord::RecordNotUnique => exception
      errors.add :form, "'#{igrf.form.file.original_filename}' already exists"
      false
    end
  end
end
