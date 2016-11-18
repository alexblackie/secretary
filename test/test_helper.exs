ExVCR.Config.cassette_library_dir("fixtures/vcr_cassettes")
ExVCR.Config.filter_sensitive_data(Application.get_env(:secretary, :github_token), "<GITHUB_TOKEN>")

ExUnit.start()
