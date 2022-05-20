#Request url for sub-categories
url = "https://www.disco.com.ar/_v/private/graphql/v1?workspace=master&maxAge=long&appsEtag=remove&domain=store&locale=es-AR&__bindingId=0beab475-23b8-4674-b38a-956cc988dade"
# method: 'POST',
# body: '{"operationName":"categoryChildren","variables":{},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"3630a63bf8c6e85633d2eec9b120514b860c329a6b884a9240b5740aee65040b","sender":"discoargentina.store-theme@4.x","provider":"vtex.catalog-graphql@1.x"},"variables":"eyJpZCI6IjE1In0="}}'
id_list = ['eyJpZCI6IjE1In0=', 'eyJpZCI6IjIifQ==']
cat_name = ['electro', 'bebidas']

id_list.each_with_index do |id, i|
    pages << {
        url: url,
        method: 'POST',
        page_type: 'categories',
        body: '{"operationName":"categoryChildren","variables":{},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"74ae600ac3f4b6daeeba5232317a074d971947fe15481c9147334cd0ab3b01bc","sender":"discoargentina.store-theme@4.x","provider":"vtex.catalog-graphql@1.x"},"variables":"'+ id +'"}}',
        headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip, deflate, br',
            'Accept-Language' => 'en-US,en;q=0.9',
            'Content-Type' => 'application/json',
            'Cookie' => 'VtexWorkspace=master%3A-; _gcl_au=1.1.49149787.1651585567; VtexRCSessionIdv7=d3be44ad-b154-410a-84d2-87e4c841d1f5; __kdtv=t%3D1651585567876%3Bi%3D7921796da644463ec0ebe23f323354a906a8e9e8; _kdt=%7B%22t%22%3A1651585567876%2C%22i%22%3A%227921796da644463ec0ebe23f323354a906a8e9e8%22%7D; _fbp=fb.2.1651585567972.1086228479; _hjFirstSeen=1; _hjIncludedInSessionSample=0; _hjSession_704952=eyJpZCI6IjJiYWIwM2MxLTJkZTYtNGM3My04YjVlLTA3ZTc0YTg0YmQ1MiIsImNyZWF0ZWQiOjE2NTE1ODU1NjgxMTgsImluU2FtcGxlIjpmYWxzZX0=; _hjIncludedInPageviewSample=1; _hjAbsoluteSessionInProgress=0; biggy-session-discoargentina=JSPKNhqTy85gKOzCYz8Kv; biggy-anonymous=ZqOS2vSiJvoOi1hm1AYS1; rcs_anonymousUserId.s6111305b77c6930487ac1b20=fec8b03d0d49b8f1672332b828e9b93344ceee59; rcs_session.s6111305b77c6930487ac1b20=ce569b864e2f798aa208c6a0a051a06c0ea75f7c; rcs_storeId.sdiscoargentina=6111305b77c6930487ac1b20; VtexRCMacIdv7=06aa699a-8844-42f1-91ab-6a6531bbfae8; _ga=GA1.3.57669143.1651585570; _gid=GA1.3.630012097.1651585570; _hjShownFeedbackMessage=true; checkout.vtex.com=__ofid=cc544275165e40138f09f04845a8c515; janus_sid=213b82a4-ff51-4374-9e02-cccb9b887eed; .ASPXAUTH=227FC879D4A458BC76948F5E7E88F8C2882196E93CCEBC810DC747F538257F79E2B136EAF06CC02C235EF126B717733F3E6C1588182A33A1989CDF88179A440F942F5A04E038064B386C65A8801A8130849B94D0E376855A51C09E129B70EC2D8BD058B90F1E74CE52E0BA4F54E32BDD4DCC686C0C5EB907CD69793FB013367047999FF0084F4DB168798AA0C2735A45A78262AA5A6DD41231E1F9FCE72B99BEA8028E3F; vtex_session=eyJhbGciOiJFUzI1NiIsImtpZCI6IjYyMzc0RDRFMTAyMkE0QzhDNzREQzMxMEIxNDZCQ0U0QzI3QzlCNkUiLCJ0eXAiOiJqd3QifQ.eyJhY2NvdW50LmlkIjoiMWUyOTg4N2YtNGQ0My00ODRmLWI1MTItMjAxM2Y0MjYwMGIxIiwiaWQiOiJkOTgxYjQ2My1lODJhLTRjYzUtODU0Zi1kMGI2NzNjYmQ3YmEiLCJ2ZXJzaW9uIjozLCJzdWIiOiJzZXNzaW9uIiwiYWNjb3VudCI6InNlc3Npb24iLCJleHAiOjE2NTIyNzcwODksImlhdCI6MTY1MTU4NTg4OSwiaXNzIjoidG9rZW4tZW1pdHRlciIsImp0aSI6IjExYjFkMWNmLTYxZWQtNDQ4NC05ZGRiLTlhODUwNTE4NmVhZiJ9.zl9U89SJ60wAIOwV6Jg4mNrNuyw9a_WZOAGlMcW84NOdysLkUKuC4HXgdM1tYYY50K8m-W6jmo2vwIL5WWHQxQ; vtex_segment=eyJjYW1wYWlnbnMiOm51bGwsImNoYW5uZWwiOiIzMyIsInByaWNlVGFibGVzIjpudWxsLCJyZWdpb25JZCI6IlUxY2phblZ0WW05aGNtZGxiblJwYm1Ga01ERXkiLCJ1dG1fY2FtcGFpZ24iOm51bGwsInV0bV9zb3VyY2UiOm51bGwsInV0bWlfY2FtcGFpZ24iOm51bGwsImN1cnJlbmN5Q29kZSI6IkFSUyIsImN1cnJlbmN5U3ltYm9sIjoiJCIsImNvdW50cnlDb2RlIjoiQVJHIiwiY3VsdHVyZUluZm8iOiJlcy1BUiIsImFkbWluX2N1bHR1cmVJbmZvIjoiZXMtQVIiLCJjaGFubmVsUHJpdmFjeSI6InB1YmxpYyJ9; _hjSessionUser_704952=eyJpZCI6IjY1ZjQ4MDQ0LTJhNjktNTU3NC1hNzcyLTUyMzUxMzIzOTVjYyIsImNyZWF0ZWQiOjE2NTE1ODU1NjgxMDIsImV4aXN0aW5nIjp0cnVlfQ==; vtex_binding_address=discoargentina.myvtex.com/; _gat_UA-2998448-11=1; biggy-event-queue=eyJzZXNzaW9uIjoiSlNQS05ocVR5ODVnS096Q1l6OEt2IiwiYW5vbnltb3VzIjoiWnFPUzJ2U2lKdm9PaTFobTFBWVMxIiwidXJsIjoiaHR0cHM6Ly93d3cuZGlzY28uY29tLmFyL2VsZWN0cm8iLCJhZ2VudCI6Ik1vemlsbGEvNS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzE1XzcpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS8xMDAuMC40ODk2LjEyNyBTYWZhcmkvNTM3LjM2IiwidHlwZSI6InNlc3Npb24ucGluZyIsImFiIjoibWFzdGVyIn0=',
            'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36'
        },
        vars: {
            cat_name: cat_name[i]   
        }
    }
end