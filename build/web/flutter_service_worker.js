'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "4a0f87d033bc099c7496206369e9769b",
"assets/AssetManifest.bin.json": "32fa7256c9f538f32ca886eb8f1c59a9",
"assets/assets/demo.jpg": "fd8a5cdd4226cfe923baa1cdb9b10575",
"assets/assets/demo2.jpg": "bdd9ea8bc22bc649838cbba8ebce3d7b",
"assets/assets/images/9876479.jpg": "b5c322874a056eede26f1c8d1ff3c0cf",
"assets/assets/images/Logo.jpg": "a426b925777a9e272b84ef0cec5b575a",
"assets/assets/images/logo1.png": "efcf3784d047fbfe4e450aaeafa451c1",
"assets/assets/images/logo2.png": "4d007c1c93644de5b109238756ccda44",
"assets/assets/images/logo3.png": "27a4522ab082134510577b019ae09afd",
"assets/assets/images/normaluser.jpg": "c6bad6465e91f65cd9a36ee3d4d23081",
"assets/assets/images/signlanguser.png": "38375af9f09e8ea6b21b297cf623008a",
"assets/assets/images/Signs.png": "ddf271fbdcfe640e3e08881abd0136ec",
"assets/assets/labels.txt": "1de158379282009096ee8c635e820167",
"assets/assets/logo2.jpg": "fa1f147708ab1c3776dce5f73c394fe3",
"assets/assets/model/model.tflite": "40d36909c6cb93d0644ae62f53a7ef70",
"assets/assets/model/signmodel.tflite": "7977bb1d605da92f4cedebaa281f1353",
"assets/assets/model.tflite": "4a19f7cefdc7dce874fdcf0851b3a208",
"assets/assets/models/hand_landmark.tflite": "614f067282328267c4b9825eba9f8b47",
"assets/assets/models/hand_landmark_3d.tflite": "682243274b9b1b587eb25a83ddfacc1f",
"assets/assets/models/model.tflite": "40d36909c6cb93d0644ae62f53a7ef70",
"assets/assets/models/palm_detection_without_custom_op.tflite": "f64675f216d82a5e44ba61b4a6cdc932",
"assets/assets/models/signmodel.tflite": "7977bb1d605da92f4cedebaa281f1353",
"assets/assets/placeholder.png": "03ac055c0406d016c5b322435b3eda4f",
"assets/assets/signease.png": "03ac055c0406d016c5b322435b3eda4f",
"assets/assets/Signs/friend.jpg": "91c83f6c4edcc3fde90b1e8c6ce1fd10",
"assets/assets/Signs/goodbye.jpg": "19706b4769fcbabd39c434c815a82ea1",
"assets/assets/Signs/hello.jpg": "64c22a814f509e37f47e19af554841aa",
"assets/assets/Signs/help.jpg": "34efb6ab8d3a52c915ba6538de7f1b2f",
"assets/assets/Signs/more.png": "53fe9f0828f5919627b39ae18eaeefdb",
"assets/assets/Signs/no.png": "4f56a48a3f677fd35b468e85a307e1bc",
"assets/assets/Signs/please.jpg": "1751c4886fe399ca8ab1e2b9896e5130",
"assets/assets/Signs/sorry.png": "3aa707557dd90565aa2e4461d8c3f3d2",
"assets/assets/Signs/thankyou.jpg": "852e3b3531e1aeaf9e5b8707c4734728",
"assets/assets/Signs/yes.jpg": "cbb0161633b0f4991d9560f03ebb93c0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "583d5fe624f67b025ffdb6c2bf548524",
"assets/NOTICES": "067a96a0c63aa3792551f517228b0bea",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "dd7c8a3160563b7cb2338254c4056f52",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "e6dec8451b93ba95eb1f2274a8541706",
"/": "e6dec8451b93ba95eb1f2274a8541706",
"main.dart.js": "822e9b8337369ef0e5b7692c0ef5bf81",
"manifest.json": "fa44fd00c9de30687c4a7989b8e6915e",
"version.json": "20977fff9eac9d56dad7c2061e6f4600"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
