require 'rails_helper'

RSpec.describe Api::V1::CirclesController, type: :controller do
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
