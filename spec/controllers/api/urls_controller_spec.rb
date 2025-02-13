RSpec.describe Api::UrlsController, type: :controller do
  let(:parsed_body) { JSON.parse(response.body) }

  describe "POST 'create'" do
    context 'successful' do
      let(:params) { { url: { original_url: 'https://google.com' } } }

      it 'creates a record' do
        expect { post :create, params: params }.to change { Url.count }.by(1)
      end

      it 'saves correct original_url' do
        post :create, params: params

        expect(Url.last.original_url).to eq(params[:url][:original_url])
      end

      it 'returns the slug of created record' do
        post :create, params: params

        last_url_obj =    Url.last
        created_url_obj = Url.find_by(slug: parsed_body['slug'])

        expect(created_url_obj).to eq(last_url_obj)
      end
    end

    context 'unsuccessful' do
      context 'when invalid params (missing original_url)' do
        let(:params) { { url: { original_url: '' } } }

        it "doesn't create a new record" do
          expect { post :create, params: params }.not_to change { Url.count }
        end
      end

      context 'when invalid params (invalid url format)' do
        let(:params) { { url: { original_url: 'test' } } }

        it "doesn't create a new record" do
          expect { post :create, params: params }.not_to change { Url.count }
        end

        it 'returns a 422 status' do
          post :create, params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          post :create, params: params

          expect(parsed_body['errors']).to eq(['Original url is not valid'])
        end
      end
    end
  end
end