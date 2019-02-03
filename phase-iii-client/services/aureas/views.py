from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.decorators import parser_classes
from rest_framework.parsers import JSONParser
import json


def index(request):
    return HttpResponse("Hello, world. You're at the Aureas index.")


@api_view(['GET', 'POST'])
@parser_classes((JSONParser,))
def get_clusters(request):
    if request.method == 'POST':
        data = request.data
        directory = data['dir']
        files = data['files']

        return HttpResponse(json.dumps(data, separators=(',', ':')))
