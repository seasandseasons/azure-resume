import logging
import json
import azure.functions as func


def main(req: func.HttpRequest, doc:func.DocumentList, out:func.Out[func.Document]) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    counters_json = []
    for counter in doc:
        counter_json = {
            "id": counter['id'],
            "counter": counter['counter']
        }
        counters_json.append(counter_json)

    # increment the counter value in Cosmos DB
    counter['counter'] += 1
    out.set(counter)
    
    return func.HttpResponse(
            json.dumps(counters_json),
            status_code=200,
            mimetype="application/json" 
    )
