import Foundation

extension URLRequest {
	init(
		url: URL,
		method: HTTPMethod,
		parameters: [String: Any]? = nil,
		headers: [String: String]? = nil
	) throws {
		guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { //vrif que l'URL est valide
			throw URLError(.badURL)
		}

		self.init(url: url)

		httpMethod = method.rawValue //de l'énum HTTP Method

		if let parameters = parameters { //si paramètres fournis
			switch method {
			case .GET: //pour méthode get : ils sont fournis dans l'URL
				encodeParametersInURL(parameters, components: components)
			case .POST: //pour post: ils sont dnas le corps de la requête
				try encodeParametersInBody(parameters)
			}
		}

		if let headers = headers { //si en tetes fournies, chacune ajoutée à la requête
			for (key, value) in headers {
				setValue(value, forHTTPHeaderField: key)
			}
		}
	}

	private mutating func encodeParametersInURL( //ajoute les paramètres à l'URL en queryItems (clé-valeur)
		_ parameters: [String: Any],
		components: URLComponents
	) {
		var components = components
		components.queryItems = parameters
			.map { ($0, "\($1)") }
			.map { URLQueryItem(name: $0, value: $1) }
		url = components.url
	}

	private mutating func encodeParametersInBody(//encode les paramèters dans le corps de la requête
		_ parameters: [String: Any]
	) throws {
		setValue("application/json", forHTTPHeaderField: "Content-Type")
		httpBody = try JSONSerialization.data(
			withJSONObject: parameters,
			options: .prettyPrinted
		)
	}
}
