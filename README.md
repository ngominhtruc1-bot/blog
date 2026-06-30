# Blog Lưu Thị Mơ

Website blog cá nhân tĩnh (HTML thuần, không cần build). Tự động đăng qua GitHub → Vercel.

## Cách đăng bài mới
1. Viết bài markdown trong `output/` của vault.
2. Tạo file `bai-N.html` mới trong thư mục này (theo mẫu các bài có sẵn).
3. Thêm thẻ bài viết vào `index.html`.
4. Commit & push lên GitHub → Vercel tự động cập nhật web trong ~30 giây.

## Cấu trúc
- `index.html` — trang chủ, danh sách bài
- `bai-1..5.html` — các bài viết
- `style.css` — giao diện chung
