// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleNFTMarket
 * @dev 简易NFT市场合约，支持铸造、上架/下架、购买、查询在售NFT
 */
contract SimpleNFTMarket {
    // ======== 状态变量 ========
    // NFT结构体定义
    struct NFT {
        uint256 id;          // NFT唯一ID（自增）
        address owner;       // 所有者地址
        uint256 price;       // 售价（单位：wei）
        bool forSale;        // 是否在售
    }

    // 存储所有NFT（ID => NFT）
    mapping(uint256 => NFT) public nfts;
    // 下一个待铸造的NFT ID（自增计数器）
    uint256 public nextNFTId;
    // 追踪在售NFT的ID列表
    uint256[] public forSaleNFTs;

    // ======== 修饰器 ========
    /**
     * @dev 校验调用者是NFT的所有者
     * @param nftId NFT的ID
     */
    modifier onlyNFTOwner(uint256 nftId) {
        require(nfts[nftId].owner == msg.sender, "Not NFT owner");
        _;
    }

    /**
     * @dev 校验NFT存在
     * @param nftId NFT的ID
     */
    modifier nftExists(uint256 nftId) {
        require(nftId < nextNFTId, "NFT does not exist");
        _;
    }

    // ======== 核心功能 ========
    /**
     * @dev 铸造新NFT
     * @return 新铸造NFT的ID
     */
    function mint() external returns (uint256) {
        uint256 newNFTId = nextNFTId;
        
        // 初始化NFT数据：ID、所有者、初始价格0、未上架
        nfts[newNFTId] = NFT({
            id: newNFTId,
            owner: msg.sender,
            price: 0,
            forSale: false
        });

        // ID自增
        nextNFTId++;

        return newNFTId;
    }

    /**
     * @dev 上架NFT
     * @param nftId 要上架的NFT ID
     * @param price 上架价格（wei）
     */
    function listNFT(uint256 nftId, uint256 price) 
        external 
        nftExists(nftId)
        onlyNFTOwner(nftId)
    {
        NFT storage nft = nfts[nftId];
        
        // 校验：未上架 + 价格>0
        require(!nft.forSale, "NFT already for sale");
        require(price > 0, "Price must be > 0");

        // 更新NFT状态
        nft.price = price;
        nft.forSale = true;

        // 添加到在售列表
        forSaleNFTs.push(nftId);
    }

    /**
     * @dev 下架NFT
     * @param nftId 要下架的NFT ID
     */
    function unlistNFT(uint256 nftId) 
        external 
        nftExists(nftId)
        onlyNFTOwner(nftId)
    {
        NFT storage nft = nfts[nftId];
        
        // 校验：已上架
        require(nft.forSale, "NFT not for sale");

        // 更新NFT状态
        nft.forSale = false;

        // 从在售列表移除（高效移除：替换最后一个元素+pop）
        _removeFromForSaleList(nftId);
    }

    /**
     * @dev 购买NFT
     * @param nftId 要购买的NFT ID
     */
    function buyNFT(uint256 nftId) 
        external 
        payable 
        nftExists(nftId)
    {
        NFT storage nft = nfts[nftId];
        
        // 校验：已上架 + 支付金额等于售价 + 购买者不是所有者
        require(nft.forSale, "NFT not for sale");
        require(msg.value == nft.price, "Incorrect payment amount");
        require(msg.sender != nft.owner, "Cannot buy your own NFT");

        // 保存原所有者地址（避免状态更新后丢失）
        address previousOwner = nft.owner;

        // 更新NFT状态：转移所有权 + 下架
        nft.owner = msg.sender;
        nft.forSale = false;

        // 从在售列表移除
        _removeFromForSaleList(nftId);

        // 转账给原所有者（使用call避免transfer的gas限制）
        (bool success, ) = previousOwner.call{value: msg.value}("");
        require(success, "Payment transfer failed");
    }

    // ======== 查询功能 ========
    /**
     * @dev 查询所有在售NFT的ID列表
     * @return 在售NFT的ID数组
     */
    function getAllForSaleNFTs() external view returns (uint256[] memory) {
        return forSaleNFTs;
    }

    /**
     * @dev 查询NFT的详细信息
     * @param nftId NFT的ID
     * @return NFT的完整信息
     */
    function getNFT(uint256 nftId) 
        external 
        view 
        nftExists(nftId)
        returns (NFT memory)
    {
        return nfts[nftId];
    }

    // ======== 内部辅助函数 ========
    /**
     * @dev 从在售列表中移除NFT ID（高效实现）
     * @param nftId 要移除的NFT ID
     */
    function _removeFromForSaleList(uint256 nftId) internal {
        uint256 length = forSaleNFTs.length;
        for (uint256 i = 0; i < length; i++) {
            if (forSaleNFTs[i] == nftId) {
                // 将最后一个元素移到当前索引，然后删除最后一个元素
                forSaleNFTs[i] = forSaleNFTs[length - 1];
                forSaleNFTs.pop();
                break;
            }
        }
    }
}