class JsTestsController < ApplicationController
  def index
    render :index, layout: "tests"
  end
end
