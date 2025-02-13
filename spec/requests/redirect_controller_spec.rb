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
    end

    context 'when slug doesn\'t exists' do
      it 'returns a 404 status' do
        get "/non-existent"

        expect(response).to have_http_status(:not_found)
      end

      it do
        get "/non-existent"

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)['error']).to eq('Not found')
      end
    end
  end
end