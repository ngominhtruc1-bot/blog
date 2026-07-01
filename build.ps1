# Builder: ráp bai-17..35 từ _articles.json + chèn thẻ bài (16..35) vào index.html
$ErrorActionPreference = 'Stop'
$web = 'D:\não mơ\web'
$enc = New-Object System.Text.UTF8Encoding($false)  # UTF-8 KHÔNG BOM

$json = [System.IO.File]::ReadAllText("$web\_articles.json")
$arts = $json | ConvertFrom-Json

$author = 'Tôi là Lưu Thị Mơ, sinh năm 1991, quê Hiệp Hòa, Bắc Giang. Từng là công nhân may, nay tôi đang học marketing online và AI, xây thương hiệu cá nhân theo cách "vừa học vừa chia sẻ lại". Tôi viết cho những người phụ nữ muốn làm lại cuộc đời mình từ con số 0 — như tôi.'

# Tiêu đề rút gọn cho link nội bộ / thẻ (bai 1..16 cố định)
$titles = @{
 1='Hành trình tôi làm lại cuộc đời từ con số 0'
 2='3 bài học tiền bạc từ nghề công nhân may'
 3='Người không rành công nghệ bắt đầu với AI'
 4='Điều gì khiến một người dám thay đổi cuộc đời'
 5='Gửi người phụ nữ đang thấy mình không còn lựa chọn'
 6='Kiếm thu nhập online: 3 lầm tưởng đã giữ chân tôi'
 7='Kiếm thu nhập online cho người mới: lộ trình 5 bước'
 8='Vượt qua nỗi sợ để thấy sức mạnh bên trong'
 9='Sắp xếp thời gian học khi vừa đi làm vừa lo gia đình'
 10='Xây thương hiệu cá nhân từ con số 0'
 11='5 câu lệnh AI đầu tiên cho phụ nữ ngại công nghệ'
 12='Kiếm tiền online với 0 đồng vốn: thật hay ảo?'
 13='Hội chứng "mình không đủ giỏi" và cách tôi đi tiếp'
 14='Nỗi sợ bị người quen đánh giá khi đăng bài'
 15='Biến câu chuyện đời thường thành nội dung'
 16='Đề tài cốt lõi của bạn nằm ở đâu?'
}
# Link nội bộ "Đọc thêm" cho từng bài mới
$related = @{
 17=@(14,15,10); 18=@(11,3,15); 19=@(12,6,13); 20=@(10,9,7); 21=@(9,8,4)
 22=@(9,15,7); 23=@(5,14,8); 24=@(13,8,4); 25=@(10,16,1); 26=@(7,6,16)
 27=@(13,12,19); 28=@(3,9,11); 29=@(8,14,13); 30=@(11,3,18); 31=@(14,24,8)
 32=@(15,21,22); 33=@(4,8,1); 34=@(15,25,13); 35=@(20,21,33)
}

# Nạp tiêu đề bài mới vào $titles để dựng link nội bộ
foreach ($a in $arts) { $titles[[int]$a.n] = [string]$a.title }

function Html-Escape([string]$s){ $s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' }

$head = @'
<!DOCTYPE html>
<html lang="vi">
<head>
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-P76P78QC');</script>
  <!-- End Google Tag Manager -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
'@

$headerBlock = @'
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-P76P78QC"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
  <header class="site-header">
    <div class="wrap">
      <div class="brand">Lưu Thị <span>Mơ</span></div>
      <nav class="nav">
        <a href="index.html">Trang chủ</a>
        <a href="index.html#bai-viet">Bài viết</a>
      </nav>
    </div>
  </header>
'@

$footer = @'
  <footer class="site-footer">
    <div class="wrap">
      <p>© 2026 Lưu Thị Mơ · Hành trình làm lại cuộc đời từ con số 0</p>
    </div>
  </footer>
</body>
</html>
'@

foreach ($a in $arts) {
  $n = [int]$a.n
  if ($a.skipFile) { continue }
  $rel = $related[$n]
  $relItems = ($rel | ForEach-Object { "        <li><a href=`"bai-$_.html`">$(Html-Escape $titles[[int]$_])</a></li>" }) -join "`n"
  $title = Html-Escape ([string]$a.title)
  $meta  = Html-Escape ([string]$a.metaDescription)
  $tag   = Html-Escape ([string]$a.tag)

  $html = @"
$head  <title>$title — Lưu Thị Mơ</title>
  <meta name="description" content="$meta">
$headerBlock
  <article class="article wrap">
    <span class="tag">$tag</span>
    <h1>$title</h1>

$($a.bodyHtml)

    <div class="related">
      <strong>Đọc thêm trên hành trình này:</strong>
      <ul>
$relItems
      </ul>
    </div>

    <hr>

    <div class="author-box">
      <strong>Về tác giả:</strong> $author
    </div>

    <a class="back-link" href="index.html">Về trang chủ</a>
  </article>

$footer
"@
  [System.IO.File]::WriteAllText("$web\bai-$n.html", $html, $enc)
  Write-Output "Đã ghi bai-$n.html"
}

# ====== Cập nhật index.html: chèn thẻ bài 35..16 lên đầu ======
$cardData = @{}
foreach ($a in $arts) { $cardData[[int]$a.n] = $a }
# bai-16 (đã có sẵn file) — thêm thẻ thủ công
$cardData[16] = [pscustomobject]@{
  n=16; tag='Thương hiệu cá nhân'
  title='Đề tài cốt lõi của bạn nằm ở đâu? Cách tôi tìm ra ngách của mình từ câu chuyện đời thường'
  cardExcerpt='Bạn không cần phát minh ra một ngách mới. Một cựu công nhân may chỉ cách tìm đề tài cốt lõi cho thương hiệu cá nhân ngay từ chính câu chuyện bạn đã sống.'
}

$cards = foreach ($n in 35..16) {
  $c = $cardData[$n]
  if (-not $c) { continue }
@"
    <article class="post-card">
      <span class="tag">$(Html-Escape ([string]$c.tag))</span>
      <h2><a href="bai-$n.html">$(Html-Escape ([string]$c.title))</a></h2>
      <p>$(Html-Escape ([string]$c.cardExcerpt))</p>
      <a class="read-more" href="bai-$n.html">Đọc tiếp</a>
    </article>
"@
}
$cardsBlock = ($cards -join "`n`n")

$idxPath = "$web\index.html"
$idx = [System.IO.File]::ReadAllText($idxPath)
if ($idx -match 'bai-35\.html') {
  Write-Output 'index.html đã có bài mới — bỏ qua chèn.'
} else {
  $marker = '<main class="posts wrap" id="bai-viet">'
  $idx = $idx.Replace($marker, $marker + "`n`n" + $cardsBlock)
  [System.IO.File]::WriteAllText($idxPath, $idx, $enc)
  Write-Output 'Đã cập nhật index.html'
}
Write-Output 'XONG'
