# frozen_string_literal: true

class Api::V1::CirclesController < ApplicationController
  def update
    @circle = Circle.find(params[:id])

    render_errors(@circle) and return unless @circle.update(circle_params)
  end

  private

  def circle_params
    params.require(:circle)
          .permit(:x, :y)
  end
end
