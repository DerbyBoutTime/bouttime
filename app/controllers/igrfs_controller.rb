class IgrfsController < ApplicationController
  def show
    @form = InterleagueGameReportingForm.find(params[:id])
    @game = @form.game
  end

  def new
    @form = InterleagueGameReportingForm.new
  end

  def create
    @form = InterleagueGameReportingForm.new(strong_parameters)

    if @form.save
      @form.game = IgrfImporter.import(@form.form.file.file)

      redirect_to @form
    else
      render "new"
    end
  end

  private

  def strong_parameters
    params.
      fetch(:interleague_game_reporting_form, {}).
      permit(:form)
  end
end
