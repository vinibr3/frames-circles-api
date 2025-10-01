# frozen_string_literal: true

class Api::V1::Frames::CirclesController < ApplicationController
  def create
    frame = Frame.find(params[:frame_id])
    @circle = frame.circles.build(circle_params)

    render_errors(@circle) and return unless @circle.save
  end

  private

  def circle_params
    params.require(:circle)
          .permit(:x, :y, :diameter)
  end
end
