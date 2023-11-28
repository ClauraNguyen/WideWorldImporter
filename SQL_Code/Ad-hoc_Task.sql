-- 01.01. Xem toàn bộ dữ liệu bảng sales
-- 01.02. Chọn cột: mã đơn hàng, mã sản phẩm, tên sản phẩm, doanh số (quantity), doanh thu (net_sales) -- chỉ lấy các cột cần xem
-- 01.03. Giới hạn để xem thử 100 dòng dữ liệu (làm giảm việc xem dữ liệu được nhẹ hơn)
-- 01.04. Sales Admin cần xem toàn bộ thông tin của đơn hàng có ID là 104
-- 01.05. Customer Service Executive cần xem lịch sử mua hàng của khách tên Lora Cronin
-- 01.06. Customer Service Staff cần xem toàn bộ đơn hàng của khách tên Lora Cronin
   Đơn hàng phải được sắp xếp theo doanh thu (net_sales) giảm dần
-- 01.07. Xem các đơn hàng được giao đến thành phố Clayton có doanh thu lớn hơn $400.
	Đơn hàng có doanh thu lớn nhất xếp trước
-- 01.08. Xem mã đơn hàng, tên sản phẩm, doanh thu của những đơn được giao đến thành phố Hammond có doanh thu lớn hơn hoặc bằng $500
-- 01.09. Xem các đơn hàng có doanh thu trên $800 nhưng có ít hơn 10 sản phẩm
-- 01.10. Customer Service Executive cần xem đơn hàng của các khách hàng có tên là John Aufderhar, Madalyn Roob
-- 01.11. Để kiểm tra gian lận, Fraud Analyst cần xem đơn hàng của các khách hàng có ID là 3, 61, 485
	Sắp xếp theo kết quả tên khách hàng
-- 01.12. Category Manager cần xem đơn hàng của những sản phẩm có tên chứa chữ Cotton.
Ví dụ: Awesome Cotton Shoes, Cotton Shirt
-- 01.13. Xem đơn hàng của những khách hàng có tên bắt đầu bằng chữ Ryan.
 Ví dụ: Ryan Harvey, Ryann Rice
-- 01.14. Xem đơn hàng của những sản phẩm có tên kết thức bằng chữ Shoes hoặc Coat
Ví dụ: Marble Shoes, Rubber Shoes, Aluminum Coat.
-- 01.15. Xem top 20 đơn hàng có doanh thu cao nhất được giao đến thành phố Athens

BKT:
K01. Để phân tích sâu hơn, Area Sales Manager cần lấy toàn bộ đơn hàng của bang LA, đơn nào có doanh thu cao nhất thì xem trước
K02. Sales Supervisor cần xem đơn hàng của các thành phố Lincoln, Baton Rouge
K03. Associate Brand Manager cần xem đơn hàng của các sản phẩm 175, 99
Sắp xếp kết quả theo tên sản phẩm.
K04. Xem đơn hàng của những khác hàng có tên chứa chữ Davi.
K05. Xem đơn hàng những sản phẩm có tên bắt đầu bằng chữ Light hoặc Synergis.
K06. Xem đơn hàng những khách hàng có tên kết thúc bằng chữ Walker hoặc King.
K07. Top 50 đơn hàng có doanh thu cao nhất của ngành hàng Widget được giao đến bang New York

Data model: tên bảng, danh sách các cột
B1. Độ chi tiết / Data grain/ Primary Key --> tên bang *, số lượng đơn --> mỗi bang 1 dòng
B2. Xác định chỉ số / số liệu /fact --> số lượng đơn hàng --> hoàn thành data model
B3. Xác định nguồn dữ liệu, data source --> sales
B4. Xác định công thức, biến đổi  --> count sales
B5. Lập kế hoạch, plan  --> tổng hợp dữ liệu bằng group by
 
M02.01. Để lập kế hoạch kinh doanh, Sale Director muốn biết số lượng đơn hàng của từng bang.
M02.02. Để lập kế hoạch kinh doanh, sales director muốn biết doanh thu (net_sales của từng bang).
	Cột tổng doanh thu phải được đặt tên thành "net_sales"
M02.03. Để lập dự báo bán hàng, Senior Sales Analyst cần biết tổng số đơn, tổng doanh thu của từng bang. Cần đặt tên cột tổng hợp
M02.04. Để lập danh sách tặng voucher, Customer Service Supervisor cần báo cáo tổng chi tiêu (net_sales) của tùng khách hàng. Kết quả cần hiện cả mã và tên khách hàng
M02.05. Để lập kế hoạch xây thêm kho bãi, Logistics Manager cần báo cáo tổng số đơn, tổng doanh thu của từng bang, từ thành phố.
M02.06. Tổng doanh thu từ trước tới giờ
M02.07. Tính Average Order Value (AOV) của từng bang
M02.08. Doanh số (Quantity) lớn nhất từng được bán trong đơn hàng
M02.09. Doanh thu nhỏ nhất từng được bán trong một đơn hàng
M02.10. Tính tổng doanh thu của bang Texas
M02.11. Marketing Executive tại Texas cần báo cáo AOV của từng ngành hàng
M02.12. Tạo báo cáo xem mức chi tiêu cao nhất mà khách hàng từng tiêu cho 1 đơn hàng. Sắp xếp theo mức chi tiêu cao nhất giảm dần
M02.13. Để thiết kế quầy trung bày tại các cửa hàng, Marketing Executive cần báo cáo top 20 sản phẩm bán chạy nhất

- Nhóm đơn đặt hàng dựa trên doanh thu
- Cung cấp kết quả cho nhóm Marketing để chạy các chương trình khuyến mãi
	- Đối với khách hàng có giá trị cao: Chương trình giảm x% khi mua từ $xxx,
trong đó $xxx cao hơn giá trị đơn vị trung bình (AOV) của tệp khách hàng này.
	- Còn lại: Chương trình giảm giá $ khi mua đơn hàng tiếp theo có giá trị
trên $xxx, với $xxx là AOV cao hơn của tệp khách hàng này.
Dựa trên kế hoạch đó, trước tiên bạn cần nhóm các đơn hàng thành các loại sau:
+ >= $500: Giá trị cao
+ Từ $100 đến $500: Giá trị bình thường
+ Từ 0$ đến 100$: Giá trị thấp

M03.02 Công ty cần nhóm các sản phẩm để thực hiện một số phân tích sản phẩm
. Bạn cần phân nhóm sản phẩm theo chất liệu theo yêu cầu dưới đây: 
- Kim loại:  Tên sản phẩm có chứa các chữ Aluminum, Copper, Steel, Bronze, Iron
- Vải: tên sản phẩm có chứa các từ Wool, Leather, Silk, Linen, Cotton
- Khác: còn lại

M03.03 Công ty đang tìm cách tăng doanh thu tại các thị trường mới. Để làm được điều đó công ty muốn hiểu hành vi mua hàng của những bang có doanh số bán hàng tốt và hành vi đó khác với phần còn lại như thế nào.
Dựa trên kế hoạch đó, trước tiên bạn cần nhóm các trạng thái dựa trên doanh thu:
- Big 10: TX, MT, MN, NY, CO, CA, MI, NC, ND, MO
- Khác: Còn lại


K01. Công ty cần phân tích hành vi của khách hàng để tăng doanh thu.  kế hoạch ban đầu bao gồm:
- Phân nhóm đơn đặt hàng dựa trên doanh số bán hàng
- Cung cấp kết quả cho nhóm Marketing để chạy các chương trình khuyến mãi
- Đối với khách hàng mua nhiều: Mua X tặng x chương trình miễn phí cho sản phẩm A, với A sản phẩm cần thúc đẩy doanh số bán hàng.
- Còn lại: Chương trình mua x sản phẩm B tặng x sản phẩm C, với B là sản phẩm cần tăng doanh số bán hàng, C là sản phẩm có nhiều hàng tồn kho.

Theo kế hoạch đó, trước tiên bạn cần nhóm các đơn hàng thành các loại sau
dựa trên doanh số bán hàng:
+ >=10: High vo
+ Từ 2 đến 10: Normal vol
+ Từ 0 đến 2: Low vol

M04. CTE - Phân loại khách hàng, bảng tạm với WITH
