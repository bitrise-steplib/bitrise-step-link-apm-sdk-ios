require_relative './../functions.rb'

describe 'download_library' do
    it 'returns file download is successful' do
        lib_version = "latest"
        
        f = download_library("https://monitoring-sdk.firebaseapp.com/#{lib_version}/libTrace.a")
        expect(f.original_filename).to eq("libTrace.a")
    end

    it 'returns zip file download is successful' do
        lib_version = "latest"
        
        f = download_library("https://monitoring-sdk.firebaseapp.com/#{lib_version}/libTrace.a.zip")
        expect(f.original_filename).to eq("libTrace.a.zip")
    end

    it 'raises error if url is 404' do
        lib_version = "nonexistent"
        expect {
            f = download_library("https://monitoring-sdk.firebaseapp.com/#{lib_version}/libTrace.a")
        }.to raise_error(Down::NotFound)
    end
end