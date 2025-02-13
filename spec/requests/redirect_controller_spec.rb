RSpec.describe RedirectController, type: :request do
  describe 'GET /:slug' do
    context 'when slug exists' do
      let!(:url_object) { FactoryBot.create(:url) }

      it 'redirects to the original URL with a 301 status' do
        get "/#{url_object.slug}"

        expect(response).to redirect_to(url_object.original_url)
        expect(response).to have_http_status(301)
      end

      it 'returns a 301 status' do
        get "/#{url_object.slug}"

        expect(response).to have_http_status(:moved_permanently)
      end

      it 'increments the visit count' do
        expect { get "/#{url_object.slug}" }
          .to change { url_object.analytic.reload.visits }.by(1)
      end

      it 'updates the last_visit_at' do
        expect(url_object.analytic.last_visit_at).to be_nil
        get "/#{url_object.slug}"
        expect(url_object.analytic.reload.last_visit_at).to_not be_nil
      end
    end

    context 'when slug doesn\'t exists' do
      it 'returns a 404 status' do
        get '/non-existent'

        expect(response).to have_http_status(:not_found)
      end

      it 'returns correct error message' do
        get '/non-existent'

        expect(JSON.parse(response.body)['error']).to eq('Not found')
      end

      it 'returns correct content_type' do
        get '/non-existent'

        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end