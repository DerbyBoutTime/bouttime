class IgrfsController < ApplicationController
  def show
    @igrf = InterleagueGameReportingForm.find(params[:id])
    @game = @igrf.game
  end

  def new
    @form = IgrfImport.new
  end

  def create
    @form = IgrfImport.new(strong_parameters)

    if @form.save
      redirect_to @form.igrf
    else
      render "new"
    end
  end

  private

  def strong_parameters
    params.
      fetch(:igrf_import, {}).
      permit(:form)
  end
end
