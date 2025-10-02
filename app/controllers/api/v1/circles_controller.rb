# frozen_string_literal: true

class Api::V1::CirclesController < ApplicationController
  def index
    geometry =
      "<(#{params.require(:center_x)},#{params.require(:center_y)}),#{params.require(:radius)}>"

    @circles = Circle.contained(geometry)
                     .by_frame(params[:frame_id])
  end

  def update
    @circle = Circle.find(params[:id])

    render_errors(@circle) and return unless @circle.update(circle_params)
  end

  def destroy
    circle = Circle.find(params[:id])

    status = circle.destroy ? :no_content : :not_found
    head status
  end

  private

  def circle_params
    params.require(:circle)
          .permit(:x, :y)
  end
end
