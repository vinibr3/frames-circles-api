require 'rails_helper'

RSpec.describe Api::V1::Frames::CirclesController, type: :controller do
  describe 'POST create' do
    let(:frame) { create(:frame, width: 1_000_000_000, height: 1_000_000_000) }
    let(:circle_params) { attributes_for(:circle).slice(:x, :y, :diameter) }
    let(:params) { { circle: circle_params, frame_id: frame.id } }

    let(:body) { JSON.parse(response.body) }

    it 'creates circle on frame' do
      expect{ post :create, params: params, as: :json }
        .to change{ frame.reload.circles_count }.by(1)
    end

    it 'returns circle rendered' do
      post :create, params: params, as: :json

      circle = Circle.first

      expect(body).to include({ id: circle.id,
                                frame_id: frame.id,
                                x: circle_params[:x],
                                y: circle_params[:y],
                                diameter: circle_params[:diameter],
                                radius: circle.radius.to_f,
                                geometry: "((#{circle.x},#{circle.y}),#{circle.radius})",
                                created_at: circle.created_at,
                                updated_at: circle.updated_at }.as_json)
    end

    context 'when params are invalids' do
      let(:params) { { circle: { x: '', y: '', diameter: '' },
                       frame_id: frame.id } }

      before { post :create, params: params, as: :json }

      it 'returns errors' do
        expect(body).to eq({ errors: { x: ['não pode ficar em branco', 'não é um número'],
                                       y: ['não pode ficar em branco', 'não é um número'],
                                       diameter: ['não pode ficar em branco', 'não é um número'],
                                       geometry: ['não pode ficar em branco'],
                                       radius: ['não pode ficar em branco', 'não é um número'] },
                             messages: ['Ponto central no eixo x não pode ficar em branco',
                                        'Ponto central no eixo x não é um número',
                                        'Ponto central no eixo y não pode ficar em branco',
                                        'Ponto central no eixo y não é um número',
                                        'Raio não pode ficar em branco',
                                        'Raio não é um número',
                                        'Diâmetro não pode ficar em branco',
                                        'Diâmetro não é um número',
                                        'Representação geométrica não pode ficar em branco']}.as_json)
      end

      it 'response have http status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
