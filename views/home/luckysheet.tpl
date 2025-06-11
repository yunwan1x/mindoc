<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图片隐写程序</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .section {
            background: #f8f9ff;
            border-radius: 10px;
            padding: 25px;
            margin: 20px 0;
            border-left: 4px solid #667eea;
            transition: transform 0.2s ease;
        }
        
        .section:hover {
            transform: translateY(-2px);
        }
        
        .section h2 {
            color: #444;
            margin-bottom: 20px;
            font-size: 1.5em;
        }
        
        .file-input-wrapper {
            position: relative;
            display: inline-block;
            cursor: pointer;
            margin-bottom: 15px;
        }
        
        .file-input {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        
        .file-input-button {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            border: none;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .file-input-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        textarea {
            width: 100%;
            min-height: 100px;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 16px;
            resize: vertical;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }
        
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        button {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            margin: 10px 5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        button:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .result {
            background: #e8f5e8;
            border: 2px solid #4caf50;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            word-break: break-all;
        }
        
        .error {
            background: #ffe8e8;
            border: 2px solid #f44336;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            color: #d32f2f;
        }
        
        .status {
            background: #e3f2fd;
            border: 2px solid #2196f3;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            color: #1976d2;
        }
        
        .warning {
            background: #fff3e0;
            border: 2px solid #ff9800;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            color: #f57c00;
        }
        
        .download-link {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 20px;
            background: #4caf50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s ease;
        }
        
        .download-link:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔒 图片隐写程序</h1>
        
        <!-- 加密部分 -->
        <div class="section">
            <h2>📝 文字隐写加密</h2>
            <div class="file-input-wrapper">
                <input type="file" id="encodeImage" accept="image/png,image/jpeg,image/jpg" class="file-input">
                <button class="file-input-button">选择图片 (PNG/JPEG)</button>
            </div>
            <div id="encodeImageName"></div>
            
            <textarea id="secretText" placeholder="请输入要隐藏的文字信息..." oninput="updateTextInfo()"></textarea>
            <div id="textInfo" style="margin: 5px 0; color: #888; font-size: 13px;"></div>
            <div id="capacityInfo" style="margin: 10px 0; color: #666; font-size: 14px;"></div>
            
            <button onclick="encodeImage()" id="encodeBtn" disabled>🔐 开始隐写加密</button>
            
            <div id="encodeResult"></div>
        </div>
        
        <!-- 解密部分 -->
        <div class="section">
            <h2>🔍 图片解密提取</h2>
            <div class="file-input-wrapper">
                <input type="file" id="decodeImage" accept="image/png,image/jpeg,image/jpg" class="file-input">
                <button class="file-input-button">选择加密图片</button>
            </div>
            <div id="decodeImageName"></div>
            
            <button onclick="decodeImage()" id="decodeBtn" disabled>🔓 提取隐藏信息</button>
             
            <pre></pre><textarea  style="width: 100%; min-height: 200px; margin-top: 10px;  line-height: 1.4;" id="decodeResult" ></textarea></pre>
            <div id="decodeinfo"></div>
        </div>
    </div>

    <script>
        let originalImageData = null;
        let encodedImageData = null;
        let currentCapacity = 0;
        
        // 更新文本信息和容量检查
        function updateTextInfo() {
            const text = document.getElementById('secretText').value;
            const textInfoDiv = document.getElementById('textInfo');
            
            if (!text) {
                textInfoDiv.innerHTML = '';
                return;
            }
            
            const encoder = new TextEncoder();
            const bytes = encoder.encode(text);
            const lengthBytes = new Uint8Array(4);
            new DataView(lengthBytes.buffer).setUint32(0, bytes.length, true); // 小端序
            const totalBytes = lengthBytes.length + bytes.length;
            const totalBits = totalBytes * 8;
            
            // 字符统计
            const charCount = text.length;
            const chineseCount = (text.match(/[\u4e00-\u9fff]/g) || []).length;
            const englishCount = (text.match(/[a-zA-Z]/g) || []).length;
            const numberCount = (text.match(/[0-9]/g) || []).length;
            const spaceCount = (text.match(/\s/g) || []).length;
            const specialCount = charCount - chineseCount - englishCount - numberCount - spaceCount;
            
            // 显示文本统计信息
            textInfoDiv.innerHTML = `
                📊 文本信息: ${charCount} 字符 | 
                🔤 中文: ${chineseCount} | 英文: ${englishCount} | 数字: ${numberCount} | 
                💾 UTF-8 字节: ${bytes.length} | 含长度头: ${totalBytes} 字节 | 需要: ${totalBits} 位
            `;
            
            // 容量检查
            if (currentCapacity > 0) {
                const capacityDiv = document.getElementById('capacityInfo');
                const usagePercent = ((totalBits / (currentCapacity * 24)) * 100).toFixed(1);
                
                if (totalBits > currentCapacity * 24) {
                    // 超出容量
                    capacityDiv.innerHTML = `
                        <div class="error">
                            ⚠️ <strong>文本过长！</strong><br>
                            📊 当前: ${totalBits} 位 | 可用: ${currentCapacity * 24} 位<br>
                            💡 建议减少 ${Math.ceil((totalBits - currentCapacity * 24) / 24)} 个字符
                        </div>
                    `;
                    document.getElementById('encodeBtn').disabled = true;
                } else if (usagePercent > 80) {
                    // 接近容量限制
                    capacityDiv.innerHTML = `
                        <div class="warning">
                            📊 容量使用率: ${usagePercent}%<br>
                            🖼️ 图片尺寸: ${Math.sqrt(currentCapacity / 4).toFixed(0)}² 像素<br>
                            ⚠️ 接近容量限制，建议适当减少文本
                        </div>
                    `;
                    document.getElementById('encodeBtn').disabled = false;
                } else {
                    // 正常范围
                    capacityDiv.innerHTML = `
                        <div style="background: #f0f8ff; border: 1px solid #4a90e2; border-radius: 5px; padding: 10px;">
                            📊 <strong>容量使用情况</strong><br>
                            💾 使用率: <strong>${usagePercent}%</strong> | 
                            剩余可输入约 ${Math.floor((currentCapacity * 24 - totalBits) / 24)} 个字符<br>
                            ✅ 容量充足，可以进行隐写加密
                        </div>
                    `;
                    document.getElementById('encodeBtn').disabled = false;
                }
            }
        }
        
        function calculateAndShowCapacity(imageData) {
            // 总像素数 * 4 (RGBA) = 总的LSB位数
            const totalBits = imageData.width * imageData.height * 4;
            // 每个字符平均需要的位数（UTF-8编码，中文通常需要3字节=24位）
            const avgBitsPerChar = 24; // 保守估计
            const maxChars = Math.floor(totalBits / avgBitsPerChar);
            
            const capacityDiv = document.getElementById('capacityInfo');
            capacityDiv.innerHTML = `
                <div style="background: #f0f8ff; border: 1px solid #4a90e2; border-radius: 5px; padding: 10px;">
                    📊 <strong>图片隐写容量信息</strong><br>
                    🖼️ 图片尺寸: ${imageData.width} × ${imageData.height} 像素<br>
                    💾 可用存储位: ${totalBits.toLocaleString()} 位<br>
                    ✏️ 大约可隐藏: <strong>${maxChars.toLocaleString()}</strong> 个字符（包含中文）
                </div>
            `;
            
            return maxChars;
        }

        // 文件选择处理
        document.getElementById('encodeImage').addEventListener('change', async function(e) {
            const file = e.target.files[0];
            if (file) {
                document.getElementById('encodeImageName').innerHTML = `<div class="status">已选择: ${file.name}</div>`;
                document.getElementById('encodeBtn').disabled = false;
                
                // 计算隐写容量
                try {
                    document.getElementById('capacityInfo').innerHTML = '<div class="status">正在分析图片容量...</div>';
                    
                    const { imageData } = await loadImageToCanvas(file);
                    currentCapacity = calculateAndShowCapacity(imageData);
                    
                    // 如果文本框有内容，更新文本信息显示
                    updateTextInfo();
                } catch (error) {
                    document.getElementById('capacityInfo').innerHTML = `<div class="error">无法分析图片: ${error.message}</div>`;
                }
            }
        });

        document.getElementById('decodeImage').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                document.getElementById('decodeImageName').innerHTML = `<div class="status">已选择: ${file.name}</div>`;
                document.getElementById('decodeBtn').disabled = false;
            }
        });

        // 加载图片到Canvas
        function loadImageToCanvas(file) {
            return new Promise((resolve, reject) => {
                const img = new Image();
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                
                img.onload = function() {
                    canvas.width = img.width;
                    canvas.height = img.height;
                    ctx.drawImage(img, 0, 0);
                    
                    try {
                        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
                        resolve({ canvas, ctx, imageData, img });
                    } catch (error) {
                        reject(error);
                    }
                };
                
                img.onerror = function() {
                    reject(new Error('图片加载失败'));
                };
                
                const reader = new FileReader();
                reader.onload = e => img.src = e.target.result;
                reader.onerror = () => reject(new Error('文件读取失败'));
                reader.readAsDataURL(file);
            });
        }

        // 改进的隐写加密 - 使用长度前缀而非结束标记
        async function encodeImage() {
            try {
                const file = document.getElementById('encodeImage').files[0];
                const secretText = document.getElementById('secretText').value;
                
                if (!file || !secretText) {
                    throw new Error('请选择图片文件并输入要隐藏的文字');
                }
                
                document.getElementById('encodeResult').innerHTML = '<div class="status">正在处理图片...</div>';
                
                const { canvas, ctx, imageData, img } = await loadImageToCanvas(file);
                originalImageData = imageData;
                
                // UTF-8编码文本
                const encoder = new TextEncoder();
                const textBytes = encoder.encode(secretText);
                
                // 创建长度前缀（4字节，小端序）
                const lengthBytes = new Uint8Array(4);
                new DataView(lengthBytes.buffer).setUint32(0, textBytes.length, true);
                
                // 合并长度前缀和文本数据
                const combinedData = new Uint8Array(lengthBytes.length + textBytes.length);
                combinedData.set(lengthBytes);
                combinedData.set(textBytes, lengthBytes.length);
                
                // 转换为二进制字符串
                let binaryData = '';
                for (let i = 0; i < combinedData.length; i++) {
                    binaryData += combinedData[i].toString(2).padStart(8, '0');
                }
                
                // 检查图片容量
                const requiredBits = binaryData.length;
                const availableBits = imageData.data.length;
                
                if (requiredBits > availableBits) {
                    throw new Error(`文字过长！需要 ${requiredBits} 位，但图片只能提供 ${availableBits} 位存储空间`);
                }
                
                // 复制图像数据
                const newImageData = ctx.createImageData(imageData.width, imageData.height);
                newImageData.data.set(imageData.data);
                
                // LSB隐写：修改每个像素的最低位
                for (let i = 0; i < binaryData.length; i++) {
                    const bit = parseInt(binaryData[i]);
                    newImageData.data[i] = (newImageData.data[i] & 0xFE) | bit;
                }
                
                // 绘制新图像
                ctx.putImageData(newImageData, 0, 0);
                encodedImageData = newImageData;
                
                // 转换为Blob并创建下载链接
                canvas.toBlob(function(blob) {
                    const url = URL.createObjectURL(blob);
                    const timestamp = new Date().getTime();
                    const fileName = `encoded_image_${timestamp}.png`;
                    
                    // 创建可点击的下载链接
                    const downloadBtn = document.createElement('button');
                    downloadBtn.innerHTML = '💾 下载加密图片';
                    downloadBtn.style.background = '#4caf50';
                    downloadBtn.style.marginLeft = '10px';
                    downloadBtn.onclick = function() {
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = fileName;
                        document.body.appendChild(a);
                        a.click();
                        document.body.removeChild(a);
                    };
                    
                    const resultDiv = document.createElement('div');
                    resultDiv.className = 'result';
                    resultDiv.innerHTML = `
                        ✅ 隐写加密成功！<br>
                        📝 原始文字: ${secretText.length} 字符<br>
                        💾 文本字节: ${textBytes.length} 字节<br>
                        🔒 总数据: ${combinedData.length} 字节 (含4字节长度前缀)<br>
                        🔢 使用二进制位: ${binaryData.length} 位<br>
                        🖼️ 图片尺寸: ${imageData.width}×${imageData.height}<br>
                        <small style="color: #666;">使用长度前缀方式，确保完整提取</small>
                    `;
                    resultDiv.appendChild(downloadBtn);
                    
                    document.getElementById('encodeResult').innerHTML = '';
                    document.getElementById('encodeResult').appendChild(resultDiv);
                }, 'image/png');
                
            } catch (error) {
                document.getElementById('encodeResult').innerHTML = `<div class="error">❌ 加密失败: ${error.message}</div>`;
            }
        }

        // 改进的隐写解密 - 使用长度前缀读取精确数据
        async function decodeImage() {
            try {
                const file = document.getElementById('decodeImage').files[0];
                
                if (!file) {
                    throw new Error('请选择要解密的图片文件');
                }
                
                document.getElementById('decodeinfo').innerHTML = '正在提取隐藏信息...</div>';
                
                const { canvas, ctx, imageData, img } = await loadImageToCanvas(file);
                
                // 提取LSB位
                let binaryData = '';
                for (let i = 0; i < imageData.data.length; i++) {
                    binaryData += (imageData.data[i] & 1).toString();
                }
                
                // 首先提取4字节的长度前缀
                if (binaryData.length < 32) {
                    throw new Error('图片数据不足，无法读取长度信息');
                }
                
                // 读取长度前缀（前32位）
                const lengthBinary = binaryData.substring(0, 32);
                const lengthBytes = [];
                for (let i = 0; i < 32; i += 8) {
                    const byte = lengthBinary.substring(i, i + 8);
                    lengthBytes.push(parseInt(byte, 2));
                }
                
                // 使用小端序解析长度
                const dataView = new DataView(new Uint8Array(lengthBytes).buffer);
                const textLength = dataView.getUint32(0, true);
                
                console.log('检测到文本长度:', textLength);
                
                // 验证长度的合理性
                if (textLength <= 0 || textLength > 1000000) { // 1MB限制
                    throw new Error(`检测到无效的文本长度: ${textLength} 字节。可能此图片未经过隐写处理。`);
                }
                
                // 计算所需的总位数
                const totalRequiredBits = 32 + (textLength * 8); // 32位长度前缀 + 文本数据位
                
                if (binaryData.length < totalRequiredBits) {
                    throw new Error(`图片数据不足。需要 ${totalRequiredBits} 位，但只有 ${binaryData.length} 位可用。`);
                }
                
                // 提取文本数据（跳过前32位长度前缀）
                const textBinary = binaryData.substring(32, 32 + (textLength * 8));
                
                // 转换为字节数组
                const textBytes = [];
                for (let i = 0; i < textBinary.length; i += 8) {
                    const byte = textBinary.substring(i, i + 8);
                    if (byte.length === 8) {
                        textBytes.push(parseInt(byte, 2));
                    }
                }
                
                // UTF-8解码
                let extractedText = '';
                try {
                    const decoder = new TextDecoder('utf-8', { fatal: false });
                    extractedText = decoder.decode(new Uint8Array(textBytes));

                    document.getElementById('decodeResult').innerHTML = extractedText;
                    document.getElementById('decodeinfo').innerHTML = `
                    <small style="color: #666;">
                                预期长度: ${textLength} 字节 | 
                                实际提取: ${textBytes.length} 字节 | 
                                解码字符数: ${extractedText.length} 个字符 |
                                ✅ 完整提取成功
                            </small>`;
                    
                } catch (error) {
                    console.error('UTF-8解码失败:', error);
                    document.getElementById('decodeinfo').innerHTML = `
                        <div class="error">
                            ❌ UTF-8解码失败<br>
                            可能原因：数据损坏或使用了不同的编码方式<br>
                            <details style="margin-top: 10px;">
                                <summary>调试信息</summary>
                                预期文本长度: ${textLength} 字节<br>
                                实际提取字节: ${textBytes.length} 字节<br>
                                前10个字节: ${textBytes.slice(0, 10).map(b => '0x' + b.toString(16).padStart(2, '0')).join(' ')}<br>
                                解码错误: ${error.message}
                            </details>
                        </div>
                    `;
                    
                }
                
            } catch (error) {
                document.getElementById('decodeinfo').innerHTML = `<div class="error">❌ 解密失败: ${error.message}</div>`;
            }
        }
    </script>
</body>
</html>