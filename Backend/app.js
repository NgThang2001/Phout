const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;
const bodyParser = require('body-parser');
app.use(express.json());

// Tạo pool kết nối đến MySQL database
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '123456',
    database: 'shop',
    connectionLimit: 10 // Số lượng kết nối tối đa trong pool
});

app.delete('/api/deleteUserVoucher/:id_user/:code_voucher', async (req, res)  => {
    try {
        const id_user = req.params.id_user;
        const code_voucher = req.params.code_voucher;
        const connection = await pool.getConnection();
        const [result] = await connection.execute(
            'DELETE FROM user_voucher WHERE id_user = ? and code_voucher = ?', [id_user, code_voucher]
        );
        connection.release();
        if (result.affectedRows > 0) {
            res.status(201).json({ message: ' successfully' });
        } else {
            res.status(500).json({ error: 'Failed ' });
        }
    } catch (error) {
        console.error('Error creating user cart:', error);
        res.status(500).json({ error: 'Failed ' });
    }
  });

app.get('/api/searchProduct/:searchText', async (req, res) => {
    try {
        const searchText = '%' + req.params.searchText + '%'; 

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM product WHERE name_product like ? ', [searchText]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();
        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.delete('/api/deleteAllUserCart/:id_user', async (req, res)  => {
    try {
        const id_user = req.params.id_user;
        const connection = await pool.getConnection();
        const [result] = await connection.execute(
            'DELETE FROM user_cart WHERE id_user = ?', [id_user]
        );
        connection.release();
        if (result.affectedRows > 0) {
            res.status(201).json({ message: ' successfully' });
        } else {
            res.status(500).json({ error: 'Failed ' });
        }
    } catch (error) {
        console.error('Error creating user cart:', error);
        res.status(500).json({ error: 'Failed ' });
    }
  });

app.delete('/api/deleteAddress/:id_adress', async (req, res)  => {
    try {
        const id_adress = req.params.id_adress;
        const connection = await pool.getConnection();
        const [result] = await connection.execute(
            'DELETE FROM address WHERE id_address = ?', [id_adress]
        );
        connection.release();
        if (result.affectedRows > 0) {
            res.status(201).json({ message: ' successfully' });
        } else {
            res.status(500).json({ error: 'Failed ' });
        }
    } catch (error) {
        console.error('Error creating user cart:', error);
        res.status(500).json({ error: 'Failed ' });
    }
  });

app.get('/api/checkUseVoucherExist/:id_user/:code_voucher', async (req, res) => {
    try {
        const id_user = req.params.id_user;
        const code_voucher = req.params.code_voucher;

        // Kiểm tra xem id_user và code_voucher có được cung cấp không
        if (!id_user || !code_voucher) {
            res.status(400).json({ error: 'Missing parameters' });
            return;
        }

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM user_voucher WHERE id_user = ? and code_voucher = ?', [id_user, code_voucher]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});


// app.get('/api/checkUseVoucherExist/:id_user ', async (req, res) => {
//     try {
//         const id_user = req.params.id_user;
//         const code_voucher = req.params.code_voucher;


//         // Lấy một kết nối từ pool
//         const connection = await pool.getConnection();
  

//         const [rows, fields] = await connection.execute('SELECT * FROM user_voucher WHERE id_user = ? and code_voucher = ?', [id_user, code_voucher]);


//         // Trả lại kết nối vào pool sau khi sử dụng
//         connection.release();
//         res.json(rows);
//     } catch (error) {
//         console.error('Error executing query:', error);
//         res.status(500).json({ error: 'Failed to execute query' });
//     }
// });





app.post('/api/createCartUser', async (req, res) => {
    try {
        const {id_user, id_product, note_cart, quantity} = req.body;
        const connection = await pool.getConnection();
        const [result] = await connection.execute(
            'INSERT INTO user_cart (id_user, id_product, note_cart, quantity) VALUES (?, ?, ?, ?)',
            [id_user, id_product, note_cart, quantity]
        );
        connection.release();
        if (result.affectedRows > 0) {
            res.status(201).json({ message: 'User created successfully' });
        } else {
            res.status(500).json({ error: 'Failed to create user' });
        }
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

app.get('/api/getListUserNotification/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM getListUserNotification  WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();
        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.post('/api/createAddress', async (req, res) => {
    try {
        const { name_address, detail_address, building_name, note, id_user, lat, lng, receiver, phone_receiver } = req.body;
        const connection = await pool.getConnection();
        const [result] = await connection.execute(
            'INSERT INTO address (name_address, detail_address, building_name, note, id_user, lat, lng, receiver, phone_receiver) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [name_address, detail_address, building_name, note, id_user, lat, lng, receiver, phone_receiver ]
        );
        connection.release();
        if (result.affectedRows > 0) {
            res.status(201).json({ message: 'User created successfully' });
        } else {
            res.status(500).json({ error: 'Failed to create user' });
        }
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

app.post('/api/createUser', async (req, res) => {
    try {
        const { phone_number, first_name, last_name, email, point_phout } = req.body;
        const connection = await pool.getConnection();
        const [result] = await connection.execute(
            'INSERT INTO user (phone_number, first_name, last_name, email, point_phout) VALUES (?, ?, ?, ?, ?)',
            [phone_number, first_name, last_name, email, point_phout]
        );
        connection.release();
        if (result.affectedRows > 0) {
            res.status(201).json({ message: 'User created successfully' });
        } else {
            res.status(500).json({ error: 'Failed to create user' });
        }
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({ error: 'Failed to create user' });
    }
});




app.put('/api/updateUser/:id_user', async (req, res) => {
    const id_user = req.params.id_user;
    const {first_name, last_name, email } = req.body; // Sửa tại đây

    try {
        const connection = await pool.getConnection();

        // Thực hiện truy vấn cập nhật thông tin người dùng
        const [result] = await connection.query(
            'UPDATE user SET first_name = ?, last_name = ?, email = ? WHERE id_user = ?',
            [first_name, last_name, email, id_user] // Sửa tại đây
        );

        connection.release();

        // Kiểm tra xem có bản ghi nào được cập nhật không
        if (result.affectedRows > 0) {
            res.status(200).json({ message: 'User information updated successfully' });
        } else {
            res.status(404).json({ message: 'User not found or no changes made' });
        }
    } catch (error) {
        console.error('Error updating user information:', error);
        res.status(500).json({ error: 'Failed to update user information' });
    }
});

app.get('/api/getDetailUser/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM user WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();
        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/checkUserExist/:phone_number', async (req, res) => {
    try {
        const phone_number = req.params.phone_number;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM user WHERE phone_number = ?', [phone_number]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();
        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});


app.get('/api/getNewestUserAddress/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM address WHERE id_user = ? ORDER BY id_address DESC LIMIT 1', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListUserCart/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM getListUserCart WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListUserVoucher/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM getListUserVoucher WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListUserFavorite/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM getListUserFavorite WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListUserAddress/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM address WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getAddressDetail/:id_address', async (req, res) => {
    try {
        const id_address = req.params.id_address;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM address WHERE id_address = ?', [id_address]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getUserDetail/:id_user', async (req, res) => {
    try {
        const id_user = req.params.id_user;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM user WHERE id_user = ?', [id_user]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getRedeemVoucherDetail/:code_voucher', async (req, res) => {
    try {
        const code_voucher = req.params.code_voucher;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM redeem_voucher WHERE code_voucher = ?', [code_voucher]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});


app.get('/api/getListRedeemVoucher', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM redeem_voucher');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getVoucherDetail/:code_voucher', async (req, res) => {
    try {
        const code_voucher = req.params.code_voucher;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM voucher WHERE code_voucher = ?', [code_voucher]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});



app.get('/api/getListVoucher', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM voucher');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

const imageUser = 'E:/Nodejs/ShopPhout/Images/user_img';
app.use('/images', express.static(imageUser));
// Route API để hiển thị hình ảnh
app.get('/api/getUserImg/:imageName', (req, res) => {
    const imageName = req.params.imageName;
    res.sendFile(path.join(imageUser, imageName));
}); 


    const imageVoucher = 'E:/Nodejs/ShopPhout/Images/voucher_img';
    app.use('/images', express.static(imageVoucher));
    // Route API để hiển thị hình ảnh
    app.get('/api/getVoucherImg/:imageName', (req, res) => {
        const imageName = req.params.imageName;
        res.sendFile(path.join(imageVoucher, imageName));
    }); 

    const imageBanner = 'E:/Nodejs/ShopPhout/Images/banner_img';
    app.use('/images', express.static(imageBanner));
    // Route API để hiển thị hình ảnh
    app.get('/api/getBannerImg/:imageName', (req, res) => {
        const imageName = req.params.imageName;
        res.sendFile(path.join(imageBanner, imageName));
    }); 

    const imageProduct = 'E:/Nodejs/ShopPhout/Images/product_img';
    app.use('/images', express.static(imageProduct));
    // Route API để hiển thị hình ảnh
    app.get('/api/getProductImg/:imageName', (req, res) => {
        const imageName = req.params.imageName;
        res.sendFile(path.join(imageProduct, imageName));
    }); 

    const imageCategory = 'E:/Nodejs/ShopPhout/Images/category_img';
    app.use('/images', express.static(imageCategory));
    // Route API để hiển thị hình ảnh
    app.get('/api/getCategoryImg/:imageName', (req, res) => {
        const imageName = req.params.imageName;
        res.sendFile(path.join(imageCategory, imageName));
    });

    const imageDir = 'E:/Nodejs/ShopPhout/Images';
    app.use('/images', express.static(imageDir));
    // Route API để hiển thị hình ảnh
    app.get('/api/getImage/:imageName', (req, res) => {
        const imageName = req.params.imageName;
        res.sendFile(path.join(imageDir, imageName));
    });

  app.get('/api/getListBanner', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM banner');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListCategory', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM category');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListProduct', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM product');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});


app.get('/api/getListProductSuggest', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM getlistproductsuggest');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/getListProductByCategory/:id_category', async (req, res) => {
    try {
        // Lấy productId từ request parameters
        const id_category = req.params.id_category;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM product WHERE id_category = ?', [id_category]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});



app.get('/api/getProductDetail/:id_product', async (req, res) => {
    try {
        // Lấy productId từ request parameters
        const id_product = req.params.id_product;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM product WHERE id_product = ?', [id_product]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});








app.get('/api/test_category', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM category');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

// Route API để thực hiện truy vấn SELECT
app.get('/api/test', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM product');

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/test1', async (req, res) => {
    try {
        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        // Thực hiện truy vấn SELECT
        const [rows, fields] = await connection.execute('SELECT * FROM product where id_product = ?', [1]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});

app.get('/api/test3/:idcategory', async (req, res) => {
    try {
        // Lấy productId từ request parameters
        const id_category = req.params.idcategory;

        // Lấy một kết nối từ pool
        const connection = await pool.getConnection();

        const [rows, fields] = await connection.execute('SELECT * FROM product WHERE id_category = ?', [id_category]);

        // Trả lại kết nối vào pool sau khi sử dụng
        connection.release();

        res.json(rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).json({ error: 'Failed to execute query' });
    }
});


// Khởi động máy chủ
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
