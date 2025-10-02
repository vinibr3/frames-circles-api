require 'rails_helper'

RSpec.describe Api::V1::CirclesController, type: :controller do
  describe 'GET index' do
    let(:frame1) { create(:frame, x: 0.0, y: 0.0, width: 10.0, height: 10.0) }
    let(:circle1) { create(:circle, frame: frame1, x: 0.1, y: 0.1, diameter: 1.0) }

    let(:frame2) { create(:frame, x: 20.0, y: 20.0, width: 10.0, height: 10.0) }
    let(:circle2) { create(:circle, frame: frame2, x: 20.1, y: 20.1, diameter: 1.0) }

    let(:frame3) { create(:frame, x: 100.0, y: 100.0, width: 10.0, height: 10.0) }
    let(:circle3) { create(:circle, frame: frame3, x: 100.1, y: 100.1, diameter: 1.0) }

    let(:params) { { center_x: 20, center_y: 20, radius: 50 } }

    let(:body) { JSON.parse(response.body) }
    let(:circle_ids) { body['circles'].map{|c| c['id'] } }

    before { [circle1, circle2, circle3] }

    it 'returns circles contained in a circle' do
      get :index, params: params, as: :json

      expect(circle_ids).to eq([circle1.id, circle2.id])
    end

    context 'when param frame_id is present' do
      let(:params) { { center_x: 20, center_y: 20, radius: 50, frame_id: frame1.id } }

      it 'returns circles filtered by frame' do
        get :index, params: params, as: :json

        expect(circle_ids).to eq([circle1.id])
      end
    end
  end

  describe 'PUT update' do
    let(:circle) { create(:circle) }
    let(:circle_params) { attributes_for(:circle) }
    let(:params) { { circle: circle_params, id: circle.id } }

    let(:body) { JSON.parse(response.body) }

    before { put :update, params: params, as: :json }

    it 'updates circle position only' do
      expect(body).to eq({ id: circle.reload.id,
                           frame_id: circle.frame_id,
                           x: circle_params[:x],
                           y: circle_params[:y],
                           diameter: circle.diameter.to_f,
                           radius: circle.radius.to_f,
                           geometry: "((#{circle.x},#{circle.y}),#{circle.radius})",
                           created_at: circle.created_at,
                           updated_at: circle.updated_at }.as_json)
    end

    context 'when params are invalids' do
      let(:circle_params) { attributes_for(:circle).transform_values{|v| '' } }

      it 'returns errors' do
        expect(body).to eq({ errors: { x: ['não pode ficar em branco', 'não é um número'],
                                       y: ['não pode ficar em branco', 'não é um número'] },
                             messages: ['Ponto central no eixo x não pode ficar em branco',
                                        'Ponto central no eixo x não é um número',
                                        'Ponto central no eixo y não pode ficar em branco',
                                        'Ponto central no eixo y não é um número']}.as_json)
      end

      it 'response have http status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:circle) { create(:circle) }

    it 'delete circle' do
      circle

      expect{ delete :destroy, params: { id: circle.id } }
        .to change { Circle.count }.by(-1)
    end

    it 'response have http status 204' do
      delete :destroy, params: { id: circle.id }

      expect(response).to have_http_status(:no_content)
   end

   context 'when do not destroy cirle' do
     before { allow_any_instance_of(Circle).to receive(:destroy).and_return(false) }

     it 'response have http status 404' do
       delete :destroy, params: { id: circle.id }

       expect(response).to have_http_status(:not_found)
     end
   end
  end
end
