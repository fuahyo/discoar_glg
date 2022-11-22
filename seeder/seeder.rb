require "./lib/helpers"

pages << {
  url: Helpers::website,
  page_type: "main_page",
  http2: true,
  method: "GET",
  fetch_type: "browser",
}


# https://www.exito.com/_v/public/graphql/v1?workspace=master&maxAge=medium&appsEtag=remove&domain=store&locale=es-CO&__bindingId=2f829b4f-604f-499c-9ffb-2c5590f076db&operationName=Category&variables={}&extensions={"persistedQuery":{"version":1,"sha256Hash":"ddf07a67d99162e1d05ef20c79c2c072bd34c59f341e4e5cda071c33402c8b07","sender":"exito.category-menu@3.x","provider":"exito.menu-graphql@2.x"},"variables":"eyJuYW1lIjoiY2F0ZWdvcnkifQ=="}