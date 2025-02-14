RSpec.describe RedirectController, type: :request do
  describe 'GET /:slug' do
    context 'when url with slug exists' do
      let!(:url_object) { FactoryBot.create(:url) }

      it 'redirects to the original URL with a 301 status', :aggregate_failures do
        get "/#{url_object.slug}"

        expect(response).to redirect_to(url_object.original_url)
        expect(response).to have_http_status(301)
      end

      it 'returns a 301 status' do
        get "/#{url_object.slug}"

        expect(response).to have_http_status(:moved_permanently)
      end

      it 'enqueues UpdateVisitStatsJob with correct args' do
        expect { get "/#{url_object.slug}" }
          .to have_enqueued_job(UpdateVisitStatsJob).exactly(:once).with(url_object.slug)
      end

      context 'when url expired' do
        let!(:expired_url_object) { FactoryBot.create(:url) }

        before { expired_url_object.analytic.update(last_visit_at: 32.days.ago) }

        it 'redirects to the original URL with a 301 status' do
          get "/#{expired_url_object.slug}"

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when url with slug doesn\'t exists' do
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

    describe 'caching' do
      let!(:url_object) { FactoryBot.create(:url) }
      let(:cache_key) { "url:#{url_object.slug}" }

      context 'when value cached', :aggregate_failures do
        before { Rails.cache.write(cache_key, url_object.original_url, expires_in: 1.day) }

        it 'doesn\'t hit the database' do
          expect(Url).not_to receive(:includes)

          get "/#{url_object.slug}"

          expect(response).to redirect_to(url_object.original_url)
          expect(response).to have_http_status(301)
        end

        it 'uses cached value', :aggregate_failures do
          expect(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 1.day).and_call_original

          get "/#{url_object.slug}"

          expect(response).to redirect_to(url_object.original_url)
          expect(response).to have_http_status(301)
        end
      end

      context 'when value not cached' do
        it 'populates the cache' do
          expect(Rails.cache.read(cache_key)).to be_nil

          get "/#{url_object.slug}"

          expect(Rails.cache.read(cache_key)).to be_present
        end
      end

    end
  end
end