require 'rails_helper'

RSpec.describe Api::V1::FramesController, type: :controller do
  describe 'POST create' do
    let(:frame_params) { attributes_for(:frame) }
    let(:circle_params) { attributes_for(:circle) }
    let(:params) { { frame: { x: frame_params[:x],
                              y: frame_params[:y],
                              width: frame_params[:width],
                              height: frame_params[:height],
                              circles_attributes: [{ x: circle_params[:x],
                                                     y: circle_params[:y],
                                                     diameter: circle_params[:diameter] }] } } }

    let(:body) { JSON.parse(response.body) }

    before { post :create, params: params, as: :json }

    it 'returns created frame' do
      expect(body).to include(frame_params.slice(:x, :y, :width, :height).as_json)
    end

    it 'creates circles' do
      circle_attributes = Circle.first.attributes.symbolize_keys

      expect(circle_attributes).to include(circle_params.slice(:x, :y, :diameter))
    end

    context 'when params are invalids' do
      let(:params) { { frame: { x: '', y: '', width: '', height: '',
                                circles_attributes: [{ x: '', y: '', diameter: '' }] } } }

      it 'returns errors' do
        expect(body).to eq({ errors: { x: ['não pode ficar em branco', 'não é um número'],
                                       y: ['não pode ficar em branco', 'não é um número'],
                                       width: ['não pode ficar em branco', 'não é um número'],
                                       height: ['não pode ficar em branco', 'não é um número'],
                                       geometry: ['não pode ficar em branco'] },
                             messages: ['Ponto central no eixo x não pode ficar em branco',
                                        'Ponto central no eixo x não é um número',
                                        'Ponto central no eixo y não pode ficar em branco',
                                        'Ponto central no eixo y não é um número',
                                        'Largura não pode ficar em branco',
                                        'Largura não é um número',
                                        'Altura não pode ficar em branco',
                                        'Altura não é um número',
                                        'Representação geométrica não pode ficar em branco']}.as_json)
      end

      it 'response have http status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:frame) { create(:frame) }
    let(:params) { { id: frame.id } }

    it 'removes frame' do
      frame

      expect{ delete :destroy, params: params }
        .to change { Frame.count }.by(-1)
    end

    it 'response have http status 204' do
      delete :destroy, params: params

      expect(response).to have_http_status(:no_content)
    end

    context 'with frame having circles' do
      let(:frame) { create(:circle).frame }

      before { delete :destroy, params: params }

      it 'renders present circles error' do
        body = JSON.parse(response.body)

        expect(body).to eq({ errors: { circles: ['estão inseridos'] },
                             messages: ['Círculos estão inseridos'] }.as_json)
      end

      it 'response have http status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
