defmodule WebAuthnLite.CredentialPublicKey.RS256 do
  defstruct [:key, :digest_type]

  @type t :: %__MODULE__{
          key: term,
          digest_type: atom
        }

  @spec from_cbor_map(map) :: t
  def from_cbor_map(cbor_map) do
    with key_map <- %{
           "kty" => "RSA",
           "n" => cbor_map[-1] |> Base.encode64(),
           "e" => cbor_map[-2] |> Base.encode64()
         },
         {:jose_jwk_kty_rsa, key} <- JOSE.JWK.from_map(key_map).kty do
      %__MODULE__{digest_type: :sha256, key: key}
    else
      _ -> {:error, :invalid_key}
    end
  end
end