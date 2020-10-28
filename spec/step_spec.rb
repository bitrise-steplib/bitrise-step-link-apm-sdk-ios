require 'zip'
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

    it 'validate zip file contains SDK' do
        lib_version = "latest"
        hasSDK = false

        f = download_library("https://monitoring-sdk.firebaseapp.com/#{lib_version}/libTrace.a.zip")
        
        Zip::File.open(f.path) do |zip_file|
            zip_file.each do |f|
                if f.name == "libTrace.a"
                    hasSDK = true
                end
            end
        end

        expect(hasSDK).to be true
        expect(f.original_filename).to eq("libTrace.a.zip")
    end

    it 'raises error if url is 404' do
        lib_version = "nonexistent"
        expect {
            f = download_library("https://monitoring-sdk.firebaseapp.com/#{lib_version}/libTrace.a")
        }.to raise_error(Down::NotFound)
    end
end