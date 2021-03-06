defmodule WebAuthnLite.SignatureTest do
  use ExUnit.Case, async: false

  alias WebAuthnLite.Signature
  doctest Signature

  @es256_b64_url_encoded_attestation_object "o2NmbXRmcGFja2VkZ2F0dFN0bXSjY2FsZyZjc2lnWEcwRQIgA_2zNZ2yCRDELCX545G4y5ZG7R2LSuz11pw_fgueVggCIQDEY3H5X93IE-pmNvJFCrwOUx6_ljzjBq3jwEYsH-_khWN4NWOBWQLCMIICvjCCAaagAwIBAgIEdIb9wjANBgkqhkiG9w0BAQsFADAuMSwwKgYDVQQDEyNZdWJpY28gVTJGIFJvb3QgQ0EgU2VyaWFsIDQ1NzIwMDYzMTAgFw0xNDA4MDEwMDAwMDBaGA8yMDUwMDkwNDAwMDAwMFowbzELMAkGA1UEBhMCU0UxEjAQBgNVBAoMCVl1YmljbyBBQjEiMCAGA1UECwwZQXV0aGVudGljYXRvciBBdHRlc3RhdGlvbjEoMCYGA1UEAwwfWXViaWNvIFUyRiBFRSBTZXJpYWwgMTk1NTAwMzg0MjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABJVd8633JH0xde_9nMTzGk6HjrrhgQlWYVD7OIsuX2Unv1dAmqWBpQ0KxS8YRFwKE1SKE1PIpOWacE5SO8BN6-2jbDBqMCIGCSsGAQQBgsQKAgQVMS4zLjYuMS40LjEuNDE0ODIuMS4xMBMGCysGAQQBguUcAgEBBAQDAgUgMCEGCysGAQQBguUcAQEEBBIEEPigEfOMCk0VgAYXER-e3H0wDAYDVR0TAQH_BAIwADANBgkqhkiG9w0BAQsFAAOCAQEAMVxIgOaaUn44Zom9af0KqG9J655OhUVBVW-q0As6AIod3AH5bHb2aDYakeIyyBCnnGMHTJtuekbrHbXYXERIn4aKdkPSKlyGLsA_A-WEi-OAfXrNVfjhrh7iE6xzq0sg4_vVJoywe4eAJx0fS-Dl3axzTTpYl71Nc7p_NX6iCMmdik0pAuYJegBcTckE3AoYEg4K99AM_JaaKIblsbFh8-3LxnemeNf7UwOczaGGvjS6UzGVI0Odf9lKcPIwYhuTxM5CaNMXTZQ7xq4_yTfC3kPWtE4hFT34UJJflZBiLrxG4OsYxkHw_n5vKgmpspB3GfYuYTWhkDKiE8CYtyg87mhhdXRoRGF0YViUSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NBAAAAC_igEfOMCk0VgAYXER-e3H0AEDIBRoyihvjNZOR2yfjLPhulAQIDJiABIVggIXUM4qBXox--h7XwLrTlN4oPj-8bE27wjXlEZIRHL4kiWCBFllqpZSGGRUTgbLTjR5_H4oUr0SJIm3oE659m5sVxUw"
  @es256_b64_url_encoded_authenticator_data "SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2MBAAAADA"
  @es256_b64_url_encoded_client_data_json "eyJjaGFsbGVuZ2UiOiJJOV9idk5DRzNNell6Zkc2V0NPNGNhVVUwcnJjbEVNVTJETElnWmVNR3R3Iiwib3JpZ2luIjoiaHR0cDovL2xvY2FsaG9zdDo0MDAwIiwidHlwZSI6IndlYmF1dGhuLmdldCJ9"
  @es256_b64_url_encoded_signature "MEQCIH22OhUJTVAdjFoNuxcjC4Vz0Ju4N1r378sA6v-DnMugAiAYoWx2s3j6C37Vgfz04Dq_lV9ybFL3JHySPLEXJGrRhw"

  @rs256_b64_url_encoded_attestation_object "o2NmbXRmcGFja2VkZ2F0dFN0bXSjY2FsZyZjc2lnWEcwRQIgThpTAf8MepxmcrpuGcSg3zIh1YlpFbEiDyzR6OvZ5NACIQC13zBxySK7g3nYXjt1DSY_uUlSdGVqzUeh7YZ2BAcAPWN4NWOBWQLCMIICvjCCAaagAwIBAgIEdIb9wjANBgkqhkiG9w0BAQsFADAuMSwwKgYDVQQDEyNZdWJpY28gVTJGIFJvb3QgQ0EgU2VyaWFsIDQ1NzIwMDYzMTAgFw0xNDA4MDEwMDAwMDBaGA8yMDUwMDkwNDAwMDAwMFowbzELMAkGA1UEBhMCU0UxEjAQBgNVBAoMCVl1YmljbyBBQjEiMCAGA1UECwwZQXV0aGVudGljYXRvciBBdHRlc3RhdGlvbjEoMCYGA1UEAwwfWXViaWNvIFUyRiBFRSBTZXJpYWwgMTk1NTAwMzg0MjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABJVd8633JH0xde_9nMTzGk6HjrrhgQlWYVD7OIsuX2Unv1dAmqWBpQ0KxS8YRFwKE1SKE1PIpOWacE5SO8BN6-2jbDBqMCIGCSsGAQQBgsQKAgQVMS4zLjYuMS40LjEuNDE0ODIuMS4xMBMGCysGAQQBguUcAgEBBAQDAgUgMCEGCysGAQQBguUcAQEEBBIEEPigEfOMCk0VgAYXER-e3H0wDAYDVR0TAQH_BAIwADANBgkqhkiG9w0BAQsFAAOCAQEAMVxIgOaaUn44Zom9af0KqG9J655OhUVBVW-q0As6AIod3AH5bHb2aDYakeIyyBCnnGMHTJtuekbrHbXYXERIn4aKdkPSKlyGLsA_A-WEi-OAfXrNVfjhrh7iE6xzq0sg4_vVJoywe4eAJx0fS-Dl3axzTTpYl71Nc7p_NX6iCMmdik0pAuYJegBcTckE3AoYEg4K99AM_JaaKIblsbFh8-3LxnemeNf7UwOczaGGvjS6UzGVI0Odf9lKcPIwYhuTxM5CaNMXTZQ7xq4_yTfC3kPWtE4hFT34UJJflZBiLrxG4OsYxkHw_n5vKgmpspB3GfYuYTWhkDKiE8CYtyg87mhhdXRoRGF0YVkBV0mWDeWIDoxodDQXD2R2YFuP5K65ooYyx5lc87qDHZdjQQAAAAD4oBHzjApNFYAGFxEfntx9ABCUA-lV13qt8KLlxgdRaWgxpAEDAzkBACBZAQDM-x5K_C029zWk9MXsN3f4YY-Mau9qlEdIxpdxDlip1mV2XYzYsBq6feMTT-veag1Nf4vg9pFMHnjhvgEw7lVca3E88jGPXJ3B1gaQv7vOJRhdoIuD5Mt3dsAu9omMmPN3r1IgTbSRUY50fkEZiQmFbu-bVImk4yxltutSIIC4b9cNf2tqxlcBqimUCX2pAJf8xDCJYUsfptO4xNs5qIfDrWiDjzo1qIb7P6a5RYCSfFCecI9roM1ez4YiHTQQFybyyqNOcTTzp3I1iLPcg3A9x3x6OwNtqksf4suaNPmh8XTF8Ba1w60mWmBrrI8eVNCoHMTPa-pSKnQ-MKUAG71NIUMBAAE"
  @rs256_b64_url_encoded_authenticator_data "SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2MBAAAAAQ"
  @rs256_b64_url_encoded_client_data_json "eyJjaGFsbGVuZ2UiOiJMaW5wNzItMm10bzYtWFAwbmhwNnQ0TE50MEt1VVBpTXFDSlNzbTBYYWk0Iiwib3JpZ2luIjoiaHR0cDovL2xvY2FsaG9zdDo0MDAwIiwidHlwZSI6IndlYmF1dGhuLmdldCJ9"
  @rs256_b64_url_encoded_signature "SPocpzwJS-qTPuNaAgXHvxpJv0HR7D7jLJ9krDO14zYfWJchBwEgdmEyOpU9coOhXBRMzrAtnh5unxFMEA-VOoUUgUsxVp8GXDGiU1vbClbOJ0vmSuiRW2nerfOOAGB-t_DTMcVTORtKpm8KF42_Rh8Bg6_v7KwyaNRRhXf7vI0FcjH15jGtqrSXWRDuAh2Lu8gRBGGrIT_vl5nZ4n_gUuUG-5N7T--TNZFic8H2DyLb9iQB_gFexFaSvlBwb3YZlTVOmi2OXCEO-HP5jqVDi2mhYD2x8Qew2KrBHuc3LxDHgPRu3sKcAAwZ9QzhIj9E88KLRO1xyAy7nkuepkwgGw"

  test "valid?" do
    {:ok, attestation_object} =
      @es256_b64_url_encoded_attestation_object |> WebAuthnLite.AttestationObject.decode()

    public_key = attestation_object.auth_data.attested_credential_data.credential_public_key

    {:ok, authenticator_data} =
      @es256_b64_url_encoded_authenticator_data |> WebAuthnLite.AuthenticatorData.decode()

    {:ok, client_data_json} =
      @es256_b64_url_encoded_client_data_json |> WebAuthnLite.ClientDataJSON.decode()

    assert Signature.valid?(
             @es256_b64_url_encoded_signature,
             authenticator_data,
             client_data_json,
             public_key
           )

    refute Signature.valid?(
             @rs256_b64_url_encoded_signature,
             authenticator_data,
             client_data_json,
             public_key
           )

    {:ok, attestation_object} =
      @rs256_b64_url_encoded_attestation_object |> WebAuthnLite.AttestationObject.decode()

    public_key = attestation_object.auth_data.attested_credential_data.credential_public_key

    {:ok, authenticator_data} =
      @rs256_b64_url_encoded_authenticator_data |> WebAuthnLite.AuthenticatorData.decode()

    {:ok, client_data_json} =
      @rs256_b64_url_encoded_client_data_json |> WebAuthnLite.ClientDataJSON.decode()

    assert Signature.valid?(
             @rs256_b64_url_encoded_signature,
             authenticator_data,
             client_data_json,
             public_key
           )

    refute Signature.valid?(
             @es256_b64_url_encoded_signature,
             authenticator_data,
             client_data_json,
             public_key
           )
  end
end
