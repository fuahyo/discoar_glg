body = JSON.parse(content)
vars = page['vars']
body['data']['categoryChildren'].each do |cat|
    category = cat['name'].unicode_normalize(:nfkd).encode('ASCII', replace: '')
    variables = JSON.parse('{"hideUnavailableItems":true,"skusFilter":"FIRST_AVAILABLE","simulationBehavior":"default","installmentCriteria":"MAX_WITHOUT_INTEREST","productOriginVtex":false,"map":"c,c","query":"'+ vars['cat_name'] +'/'+category.downcase.gsub(',','').gsub(' ','-')+'","orderBy":"OrderByScoreDESC","from":0,"to":20,"selectedFacets":[{"key":"c","value":"'+ vars['cat_name'] +'"},{"key":"c","value":"'+category.downcase.gsub(',','').gsub(' ','-')+'"}],"operator":"and","fuzzy":"0","searchState":null,"facetsBehavior":"Static","categoryTreeBehavior":"default","withFacets":false}')
    # require 'byebug'
    # byebug
    encoded_variables = Base64.strict_encode64(JSON.generate(variables))
    url = 'https://www.disco.com.ar/_v/segment/graphql/v1?workspace=master&maxAge=short&appsEtag=remove&domain=store&locale=es-AR&__bindingId=0beab475-23b8-4674-b38a-956cc988dade&&operationName=productSearchV3&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"67d0a6ef4d455f259737e4edb1ed58f6db9ff823570356ebc88ae7c5532c0866","sender":"vtex.store-resources@0.x","provider":"vtex.search-graphql@0.x"},"variables":"'+encoded_variables+'"}'

    pages << {
        url: url,
        page_type: "sub_categories",
        method: "GET",
        headers: page['headers'],
        vars: {
            url_variables: variables,
            cat_name: vars['cat_name'],
            category: category.downcase.gsub(',','').gsub(' ','-'),
            page_num: 1,
        },
    }

end