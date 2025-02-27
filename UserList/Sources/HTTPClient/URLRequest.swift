import Foundation

extension URLRequest {
	init(
		url: URL,
		method: HTTPMethod,
		parameters: [String: Any]? = nil, //pas obligatoire
		headers: [String: String]? = nil //pas obligatoire
	) throws {
		guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { //vrif que l'URL est de type URLComponents cad qu'elle peut etre découpée en composants indiv
			throw URLError(.badURL)
		}

		self.init(url: url) //appelle l'init de la classe parent URLRequest

		httpMethod = method.rawValue //httpMethod est une propriété de la classe mère.

		if let parameters = parameters {
			switch method {
			case .GET:
				encodeParametersInURL(parameters, components: components)//param ajoutés à l'URL
			case .POST:
				try encodeParametersInBody(parameters) //ajoutés dans le corps de la requete
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
			.map { ($0, "\($1)") } // convertir valeur en chaine de caractères
			.map { URLQueryItem(name: $0, value: $1) } //crée un tableau de queryItems
		url = components.url //url avec queryItems
	}

	private mutating func encodeParametersInBody(//encode les parameters dans le corps de la requête
		_ parameters: [String: Any]
	) throws {
		setValue("application/json", forHTTPHeaderField: "Content-Type") //header content-type : type json
		httpBody = try JSONSerialization.data( // convertit des données swift en JSON
			withJSONObject: parameters, //transforme parameters en JSON
			options: .prettyPrinted //formatage avec indentations
		)
	}
}
//requete en sortie : URL avec param, methode, headers dans corps requete
