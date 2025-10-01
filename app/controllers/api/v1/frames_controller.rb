# frozen_string_literal: true

class Api::V1::FramesController < ApplicationController
  def create
    @frame = Frame.new(frame_params)

    render_errors(@frame) and return unless @frame.save
  end

  def destroy
    @frame = Frame.find(params[:id])

    head(:no_content) and return if @frame.destroy

    render_errors(@frame)
  end

  private

  def frame_params
    params.require(:frame)
          .permit(:x, :y, :width, :height, circles_attributes: [:x, :y, :diameter])
  end
end
