/*
	Copyright (C) 2016 Oisin Carr

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <curl\curl.h>

extern "C"  __declspec(dllexport) void send_post_request(int n, char *v[])
{

	if (n < 2) return;

	curl_global_init(CURL_GLOBAL_DEFAULT);
	CURL *curl = curl_easy_init();

	if (!curl) return;

	CURLcode res;
	struct curl_slist *chunk = NULL;

	for (int i = 2; i < n; i++) chunk = curl_slist_append(chunk, v[i]);

	curl_easy_setopt(curl, CURLOPT_URL, v[0]);

	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chunk);
	curl_easy_setopt(curl, CURLOPT_POST, 1L);

	char *data = v[1];

	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);

	res = curl_easy_perform(curl);

	curl_global_cleanup();

	
}