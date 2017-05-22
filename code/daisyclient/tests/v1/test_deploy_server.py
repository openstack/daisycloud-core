# Copyright 2012 OpenStack Foundation.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

import mock
import unittest
import webob
from daisyclient.v1 import client
from daisyclient.v1 import deploy_server
from daisyclient.common import http

endpoint = 'http://127.0.0.1:29292'
client_mata = {'ssl_compression': True, 'insecure': False, 'timeout': 600,
               'cert': None, 'key': None, 'cacert': ''}


class TestDeployServerManager(unittest.TestCase):
    def setUp(self):
        super(TestDeployServerManager, self).setUp()
        self.client = http.HTTPClient(endpoint, **client_mata)
        self.manager = deploy_server.DeployServerManager(self.client)

    @mock.patch('daisyclient.common.http.HTTPClient._request')
    def test_pxe_env_check(self, mock_do_request):
        def mock_request(method, url, **kwargs):
            resp = webob.Response()
            resp.status_code = 200
            body = {'deploy_server_meta': {'return_code': 0}}
            return resp, body

        mock_do_request.side_effect = mock_request
        pxe_env_check = self.manager.pxe_env_check(**version_meta)
        self.assertEqual(0, pxe_env_check.return_code)
