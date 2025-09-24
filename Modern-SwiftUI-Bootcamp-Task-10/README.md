# Modern-SwiftUI-Bootcamp-Task-10

SwiftUI ile hazırlanmış basit bir Pokémon listeleme örneği. Uygulama, PokeAPI üzerinden Pokémon listesini çeker ve her bir Pokémon için küçük bir sprite görseli ve adını gösterir.

## Kullanılan API
- PokeAPI: https://pokeapi.co/
  - Liste uç noktası: `https://pokeapi.co/api/v2/pokemon`
  - PokeAPI liste yanıtındaki her öğe, `name` ve `url` alanlarını içerir. `url` değeri genellikle şu formattadır:
    `https://pokeapi.co/api/v2/pokemon/{id}/`
  - Sprite görseli, bu `id` değeri kullanılarak şu kaynaktan oluşturulur:
    `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png`

## Kısa Açıklama
- Uygulama, PokeAPI’den Pokémon listesini indirir.
- Her satırda Pokémon adı ve uzak sunucudan yüklenen küçük sprite görseli gösterilir.
- Görseller `AsyncImage` ile yüklenir; yükleme, başarı ve hata durumlarına göre uygun yer tutucular kullanılır.
- Erişilebilirlik için temel etiketlemeler eklenmiştir.

## Mimarî
- Genel yapı: Küçük bir örnek olduğu için basitleştirilmiş bir yapı kullanılır; ağ çağrısı doğrudan görünümde yapılır.
- Modeller:
  - `PokemonListResponse` ve `Pokemon` `Codable` protokolünü kullanır.
  - Kimlik (`id`) değeri, PokeAPI’nin döndürdüğü `url` alanından türetilir.
- Görünümler:
  - `ContentView`: Listeyi gösterir, veri çekmeyi başlatır ve yüklenme durumunu yönetir.
  - `PokemonRowView`: Her satır için sprite görselini `AsyncImage` ile yükler, adı gösterir ve erişilebilirlik etiketleri sağlar.
- Ağ Katmanı:
  - `URLSession` ve `JSONDecoder` ile basit bir GET isteği yapılır.
  - Yanıt alındıktan sonra UI güncellemeleri ana iş parçacığında gerçekleştirilir.
- Görsel Yükleme:
  - `AsyncImage` ile başarı/boş/hata durumları işlenir ve yer tutucular gösterilir.
- Erişilebilirlik:
  - Satır bileşenlerinde `accessibilityLabel` ve `accessibilityElement(children: .combine)` kullanılır.
- Bağımlılıklar:
  - Harici bağımlılık yoktur; SwiftUI ve Foundation yeterlidir.
- Geliştirme Önerileri:
  - MVVM için `PokemonListViewModel` ve `PokemonAPIService` gibi katmanların eklenmesi,
  - `async/await` ile Swift Concurrency kullanımı,
  - Hata yönetiminin genişletilmesi ve önbellekleme (görsel ve yanıt) eklenmesi,
  - Birim testleri ve anlık görüntü testleri.

## Nasıl Çalışır?
1. Liste isteği `https://pokeapi.co/api/v2/pokemon` adresine yapılır.
2. Dönen yanıttaki her Pokémon’un `url` alanından kimlik (`id`) değeri çıkarılır.
3. Bu `id` ile sprite URL’si oluşturulur ve görüntü asenkron olarak yüklenir.

## Gereksinimler
- Xcode 15 veya üzeri
- iOS 17 veya üzeri (SwiftUI)

## Projeyi Çalıştırma
1. Depoyu klonlayın veya indirin.
2. Xcode ile açın.
3. Hedef cihazı/simülatörü seçip çalıştırın (Run).

## Kaynaklar
- PokeAPI Dokümantasyonu: https://pokeapi.co/docs/v2
- PokeAPI Sprites Deposu: https://github.com/PokeAPI/sprites

## Not
Bu proje eğitim amaçlıdır ve basit bir listeleme/sunum akışını göstermeyi hedefler. Üretim ortamı için hata yönetimi, önbellekleme ve ağ katmanı mimarisi genişletilmelidir.

