class IgrfImport
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :form, String

  validates :form, presence: true
  validate :imported

  def game
    @game ||= IgrfImporter.import(igrf.form.file.file) if form
  end

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

  def imported
    errors.add(:form, "Game already imported.") if game && game.igrf
  end

  def persist!
    begin
      igrf.game = game
      igrf.save!
    rescue ActiveRecord::RecordNotUnique => exception
      errors.add :form, "'#{igrf.form.file.original_filename}' already exists"
      false
    end
  end
end
