#Request url for sub-categories
url = "https://www.disco.com.ar/_v/private/graphql/v1?workspace=master&maxAge=long&appsEtag=remove&domain=store&locale=es-AR&__bindingId=0beab475-23b8-4674-b38a-956cc988dade"
# method: 'POST',
# body: '{"operationName":"categoryChildren","variables":{},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"3630a63bf8c6e85633d2eec9b120514b860c329a6b884a9240b5740aee65040b","sender":"discoargentina.store-theme@4.x","provider":"vtex.catalog-graphql@1.x"},"variables":"eyJpZCI6IjE1In0="}}'
id_list = ['eyJpZCI6IjE1In0=', 'eyJpZCI6IjIifQ==', 'eyJpZCI6IjQ2NSJ9', 'eyJpZCI6IjEifQ==', 'eyJpZCI6IjQifQ==', 'eyJpZCI6IjMifQ==', 'eyJpZCI6IjcifQ==', 'eyJpZCI6IjExIn0=', 'eyJpZCI6IjQ1NyJ9', 'eyJpZCI6IjEzIn0=', 'eyJpZCI6IjYifQ==', 'eyJpZCI6IjgifQ==', 'eyJpZCI6IjkifQ==', 'eyJpZCI6IjEwIn0=', 'eyJpZCI6IjE0In0=', 'eyJpZCI6IjE2In0=']
cat_name = ['electro', 'bebidas', 'tiempo libre', 'almacen', 'carnes', 'frutas y verduras', 'lacteos', 'perfumeria', 'bebes y ninos', 'limpieza', 'quesos y fiambres', 'congelados', 'panaderia y reposteria', 'comidas preparadas', 'mascotas', 'hogar y textil']

# id_list.each_with_index do |id, i|
#     pages << {
#         url: url,
#         method: 'POST',
#         page_type: 'categories',
#         body: '{"operationName":"categoryChildren","variables":{},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"268a6c10fb7e49938ddb1f74c1b5e72b874056c6731a0b9cbd65a614c181f4e1","sender":"discoargentina.store-theme@4.x","provider":"vtex.catalog-graphql@1.x"},"variables":"'+ id +'"}}',
#         headers: {
#             'Accept' => '*/*',
#             'Accept-Encoding' => 'gzip, deflate, br',
#             'Accept-Language' => 'en-US,en;q=0.9',
#             'Content-Type' => 'application/json',
#             'Cookie' => '_hjSessionUser_704952=eyJpZCI6ImFmZDEwNDlkLTQ5Y2QtNTljZS05NjM3LTE0NWQ3MDFiZTUzYiIsImNyZWF0ZWQiOjE2NTE4NDcxNjcwMTMsImV4aXN0aW5nIjp0cnVlfQ==; VtexWorkspace=master%3A-; _gcl_au=1.1.1416430178.1667544780; _fbp=fb.2.1667544780178.796434972; __kdtv=t%3D1651847166846%3Bi%3D529a8b804192573c1bd63411cd23152e63bf4f6a; _kdt=%7B%22t%22%3A1651847166846%2C%22i%22%3A%22529a8b804192573c1bd63411cd23152e63bf4f6a%22%7D; biggy-anonymous=u6O5OSJlKBYCB5uANA1oh; vtex_binding_address=discoargentina.myvtex.com/; VtexRCMacIdv7=b4edd7c1-e5a1-4c15-8442-8679868b7882; checkout.vtex.com=__ofid=e5a23430f43142888f719b49603c1a79; .ASPXAUTH=EB88FF2FF52334FAB14F5B405774C17135C48FC5EDE09C977AFB81A8611F503E97C4D19B0935BA019B09832E70505395096E4B4DEA49B9BD67545A926FFBEB6EAC6D0C8029468B18338882AEDCEF77F858BA9BA078B164014D4F802D1934F0AFAB4C2D0F0C08B9FA51308A7A9630F371A6B485EEC9A98AC41078C8D862FD220138BE60EBFD834ECF372825F012B1C4C385C016BCA6DDA3976E187535EC912C16527E13B5; _gid=GA1.3.431137586.1667818324; janus_sid=03da6019-b62c-42f9-bacd-0f6678077b47; VtexRCSessionIdv7=7b7d34d9-cc70-46fb-a8bc-ac6a0d6c01c2; _hjSession_704952=eyJpZCI6IjBkMDY3MzU4LTU1NzItNGY2Yy05MDk3LWUxZWVkNWMwMWVjMCIsImNyZWF0ZWQiOjE2Njc4MjA0OTA5MjAsImluU2FtcGxlIjpmYWxzZX0=; _hjAbsoluteSessionInProgress=1; biggy-session-discoargentina=iGYZoOSmGC2AvKUyFYAJZ; vtex_session=eyJhbGciOiJFUzI1NiIsImtpZCI6IkZFRkU2QTg5QUExQTY2NjJDMURCQ0ZFMDcxRUFGMEE2MTgxMTI0MTUiLCJ0eXAiOiJqd3QifQ.eyJhY2NvdW50LmlkIjoiMWUyOTg4N2YtNGQ0My00ODRmLWI1MTItMjAxM2Y0MjYwMGIxIiwiaWQiOiIzMDQ3Y2NlMy1kZTdhLTQ3NWEtYjE1OC00ZDIyYTgwN2RkMTIiLCJ2ZXJzaW9uIjo1LCJzdWIiOiJzZXNzaW9uIiwiYWNjb3VudCI6InNlc3Npb24iLCJleHAiOjE2Njg1MTI0MzksImlhdCI6MTY2NzgyMTIzOSwiaXNzIjoidG9rZW4tZW1pdHRlciIsImp0aSI6ImYzN2VlMDA0LWNjMTEtNGU3MC04NjQ2LWVkMjY1MDIyMTEyYyJ9.Lxrz8qR9woxMYuNXDpPE3fHCBdLAIY5da7cGv9iuVd-4r_ApwXQHc5mqaX2pnwbS--nSrPlzvzq8HWV5NogdsA; vtex_segment=eyJjYW1wYWlnbnMiOm51bGwsImNoYW5uZWwiOiIzMyIsInByaWNlVGFibGVzIjpudWxsLCJyZWdpb25JZCI6IlUxY2phblZ0WW05aGNtZGxiblJwYm1Ga01ETTEiLCJ1dG1fY2FtcGFpZ24iOm51bGwsInV0bV9zb3VyY2UiOm51bGwsInV0bWlfY2FtcGFpZ24iOm51bGwsImN1cnJlbmN5Q29kZSI6IkFSUyIsImN1cnJlbmN5U3ltYm9sIjoiJCIsImNvdW50cnlDb2RlIjoiQVJHIiwiY3VsdHVyZUluZm8iOiJlcy1BUiIsImFkbWluX2N1bHR1cmVJbmZvIjoiZXMtQVIiLCJjaGFubmVsUHJpdmFjeSI6InB1YmxpYyJ9; _hjIncludedInPageviewSample=1; _hjIncludedInSessionSample=0; _ga=GA1.3.2084765671.1667544782; _gat_UA-2998448-11=1; _ga_4YZ7VMXH3C=GS1.1.1667818324.5.1.1667822763.0.0.0; biggy-event-queue=eyJzZXNzaW9uIjoiaUdZWm9PU21HQzJBdktVeUZZQUpaIiwiYW5vbnltb3VzIjoidTZPNU9TSmxLQllDQjV1QU5BMW9oIiwidXJsIjoiaHR0cHM6Ly93d3cuZGlzY28uY29tLmFyL2VsZWN0cm8iLCJhZ2VudCI6Ik1vemlsbGEvNS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzE1XzcpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS8xMDcuMC4wLjAgU2FmYXJpLzUzNy4zNiIsInR5cGUiOiJzZXNzaW9uLnBpbmciLCJhYiI6Im1hc3RlciJ9',
#             'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
#         },
#         vars: {
#             cat_name: cat_name[i]
#         }
#     }
# end
pages << {
    url: "https://www.disco.com.ar/molinillo-cafe-nex-cg1250bl/p",
    page_type: "details",
    # http2: false,
    headers: {
        'X-DH-Session-ID' => "my_session"
    },
    # fetch_type: 'browser',
    method: "GET",
    # driver: {
    #     "code": "await sleep(10000);",
    #     "goto_options": {
    #         "timeout": 0,
    #         "waitUntil": "domcontentloaded",
    #     },
    # },
    # cookie: "_hjSessionUser_704952=eyJpZCI6ImFmZDEwNDlkLTQ5Y2QtNTljZS05NjM3LTE0NWQ3MDFiZTUzYiIsImNyZWF0ZWQiOjE2NTE4NDcxNjcwMTMsImV4aXN0aW5nIjp0cnVlfQ==; VtexWorkspace=master%3A-; _gcl_au=1.1.1416430178.1667544780; _fbp=fb.2.1667544780178.796434972; __kdtv=t%3D1651847166846%3Bi%3D529a8b804192573c1bd63411cd23152e63bf4f6a; _kdt=%7B%22t%22%3A1651847166846%2C%22i%22%3A%22529a8b804192573c1bd63411cd23152e63bf4f6a%22%7D; biggy-anonymous=u6O5OSJlKBYCB5uANA1oh; vtex_binding_address=discoargentina.myvtex.com/; VtexRCMacIdv7=b4edd7c1-e5a1-4c15-8442-8679868b7882; checkout.vtex.com=__ofid=e5a23430f43142888f719b49603c1a79; .ASPXAUTH=EB88FF2FF52334FAB14F5B405774C17135C48FC5EDE09C977AFB81A8611F503E97C4D19B0935BA019B09832E70505395096E4B4DEA49B9BD67545A926FFBEB6EAC6D0C8029468B18338882AEDCEF77F858BA9BA078B164014D4F802D1934F0AFAB4C2D0F0C08B9FA51308A7A9630F371A6B485EEC9A98AC41078C8D862FD220138BE60EBFD834ECF372825F012B1C4C385C016BCA6DDA3976E187535EC912C16527E13B5; vtex_session=eyJhbGciOiJFUzI1NiIsImtpZCI6IkZFRkU2QTg5QUExQTY2NjJDMURCQ0ZFMDcxRUFGMEE2MTgxMTI0MTUiLCJ0eXAiOiJqd3QifQ.eyJhY2NvdW50LmlkIjoiMWUyOTg4N2YtNGQ0My00ODRmLWI1MTItMjAxM2Y0MjYwMGIxIiwiaWQiOiIzMDQ3Y2NlMy1kZTdhLTQ3NWEtYjE1OC00ZDIyYTgwN2RkMTIiLCJ2ZXJzaW9uIjo1LCJzdWIiOiJzZXNzaW9uIiwiYWNjb3VudCI6InNlc3Npb24iLCJleHAiOjE2Njg1MTI0MzksImlhdCI6MTY2NzgyMTIzOSwiaXNzIjoidG9rZW4tZW1pdHRlciIsImp0aSI6ImYzN2VlMDA0LWNjMTEtNGU3MC04NjQ2LWVkMjY1MDIyMTEyYyJ9.Lxrz8qR9woxMYuNXDpPE3fHCBdLAIY5da7cGv9iuVd-4r_ApwXQHc5mqaX2pnwbS--nSrPlzvzq8HWV5NogdsA; vtex_segment=eyJjYW1wYWlnbnMiOm51bGwsImNoYW5uZWwiOiIzMyIsInByaWNlVGFibGVzIjpudWxsLCJyZWdpb25JZCI6IlUxY2phblZ0WW05aGNtZGxiblJwYm1Ga01ETTEiLCJ1dG1fY2FtcGFpZ24iOm51bGwsInV0bV9zb3VyY2UiOm51bGwsInV0bWlfY2FtcGFpZ24iOm51bGwsImN1cnJlbmN5Q29kZSI6IkFSUyIsImN1cnJlbmN5U3ltYm9sIjoiJCIsImNvdW50cnlDb2RlIjoiQVJHIiwiY3VsdHVyZUluZm8iOiJlcy1BUiIsImFkbWluX2N1bHR1cmVJbmZvIjoiZXMtQVIiLCJjaGFubmVsUHJpdmFjeSI6InB1YmxpYyJ9; _hjIncludedInSessionSample=1; _hjSession_704952=eyJpZCI6IjkyYjI5NTJhLTE1MTMtNDZiNC1iODYwLTBmYzY4NmVhNzUwMSIsImNyZWF0ZWQiOjE2NjgxNDc0NjE1NjgsImluU2FtcGxlIjp0cnVlfQ==; _hjIncludedInPageviewSample=1; _hjAbsoluteSessionInProgress=0; biggy-session-discoargentina=J5mqGPTgSAOzS5GivFJyu; _gid=GA1.3.601466735.1668147468; _ga=GA1.3.2084765671.1667544782; _ga_4YZ7VMXH3C=GS1.1.1668147468.8.1.1668147746.0.0.0; biggy-event-queue=",
    # headers: {
    #     'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    #     'Accept-Encoding' => 'gzip, deflate, br',
    #     'Accept-Language' => 'en-US,en;q=0.9',
    #     'service-worker-navigation-preload' => 'true',
    #     'if-none-match' => "ECFCF3D4AF9A667FE0333AE5B7588AE7",
    #     'User-Agent' => 'Mozilla/5.0 (Macitosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
    # }

}
