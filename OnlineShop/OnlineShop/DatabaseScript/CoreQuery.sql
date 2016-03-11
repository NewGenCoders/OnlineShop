CREATE DATABASE OnlineShop;
USE OnlineShop;

GO
--To keep record about status...
CREATE TABLE Status
(
	StatusId int NOT NULL IDENTITY(0,1) CONSTRAINT Status_pk PRIMARY KEY,
	StatusName nvarchar(50)
);

GO


GO
--To record the login type....login type may be admin,normal,guest and other

CREATE TABLE LoginTypes
(	LoginTypeId int NOT NULL IDENTITY(1,1) CONSTRAINT LoginTypes_pk PRIMARY KEY,
	LoginTypeName nvarchar(20) NOT NULL,
	StatusId int NOT NULL CONSTRAINT LoginTypes_Status_fk REFERENCES Status(StatusId)
);

--To create unique index for LoginTypeName.....Login Type can not be duplicate
CREATE UNIQUE INDEX LoginTypes_LoginTypeName_ui
ON LoginTypes(LoginTypeName);
GO


GO
--To  record the photos

CREATE TABLE PhotoStorages
(
	PhotoStorageId bigint NOT NULL IDENTITY(1,1) CONSTRAINT PhotoStorages_pk PRIMARY KEY,
	Photo image NOT NULL,
	StatusId int NOT NULL CONSTRAINT PhotoStorages_Status_fk REFERENCES Status(StatusId)
	
);
GO

GO
--To record the user's address and delivery address

CREATE TABLE Addresses
(
	AddressId bigint NOT NULL IDENTITY(1,1) CONSTRAINT Addresses_pk PRIMARY KEY,
	AddressName nvarchar(100) NOT NULL,
	StatusId int NOT NULL CONSTRAINT Addresses_Status_fk REFERENCES Status(StatusId)
);
GO

GO
--To record gender of user
CREATE TABLE Genders
(
	GenderId int NOT NULL IDENTITY(1,1) CONSTRAINT Genders_pk PRIMARY KEY,
	GenderName nvarchar(20) NOT NULL,
	Status bit NOT NULL DEFAULT(1)
	
);
GO

GO
--To record the name of countries

CREATE TABLE Countries
(
	CountryId int NOT NULL IDENTITY(1,1) CONSTRAINT Countries_pk PRIMARY KEY,
	CountryName nvarchar(50)NOT NULL,
	StatusId int NOT NULL CONSTRAINT Countries_Status_fk REFERENCES status(StatusId)
);

--To crate unique index for countries because country name can not be duplicate
CREATE UNIQUE INDEX Countries_CountryName_ui
ON Countries(CountryName);
GO

GO
--To record the detail information of Users

CREATE TABLE Users
(
	UserId bigint NOT NULL IDENTITY(1,1) CONSTRAINT Users_pk PRIMARY KEY,
	UserAddressId bigint NOT NULL CONSTRAINT Users_Addresses_fk REFERENCES Addresses(AddressId),
	LoginTypeId int NOT NULL CONSTRAINT Users_LoginTypes_fk REFERENCES LoginTypes(LoginTypeId),
	PhotoStorageId bigint NOT NULL CONSTRAINT Users_PhotoStoragesId_fk REFERENCES PhotoStorages(PhotoStorageId),
	GenderId int NOT NULL CONSTRAINT Users_Genders_fk REFERENCES Genders(GenderId),
	CountryId int NOT NULL CONSTRAINT Users_Countries REFERENCES Countries(CountryId),
	FullName nvarchar(50)NOT NULL,
	UserName nvarchar(50)NOT NULL,
	Password nvarchar(250)NOT NULL,
	Email nvarchar(150)NOT NULL,
	ContactNumber nvarchar(25)NOT NULL,
	UserRegisteredDate Date NOT NULL DEFAULT(GETDATE()),
	StatusId int NOT NULL CONSTRAINT Users_Status_fk REFERENCES Status(StatusId)
);

--To create unique index for Username because username can not be duplicate
CREATE UNIQUE INDEX Users_UserName_ui
ON Users(UserName);
GO


GO
--TO record the product
CREATE TABLE ProductCategories
(
	ProductCategoryId bigint NOT NULL IDENTITY(1,1) CONSTRAINT Products_Pk PRIMARY KEY,
	ProductCategoryName nvarchar(50) NOT NULL,
	ParentProductCategoryId bigint NULL, --CONSTRAINT ProductCategories_FK  REFERENCES ProductCategories(ProductCategoryId),
	ShopId bigint NOT NULL CONSTRAINT ProductCategories_Shops_fk REFERENCES Shops(ShopId),
	StatusId int NOT NULL CONSTRAINT ProductCategories_Status_fk REFERENCES Status(StatusId)
);
--To create unique index for Products
CREATE UNIQUE INDEX ProductCategories_ProductName_ShopId_ui
ON ProductCategories(ProductCategoryName,ShopId);
GO


GO
--To record Detail information about Product
CREATE TABLE Products
(
	ProductId bigint NOT NULL IDENTITY(1,1) CONSTRAINT ProductDetails_pk PRIMARY KEY,
	ProductCategoryId bigint NOT NULL CONSTRAINT Products_ProductCategories REFERENCES ProductCategories(ProductCategoryId), 
	ShopId    bigint NOT NULL CONSTRAINT ProductDetails_Shops_fk REFERENCES Shops(ShopId),
	UnitPrice money NOT NULL,
	ManufactureCompanyName nvarchar(100) NULL,
	Discount float NOT NULL DEFAULT(0),
	MaxOrder int NOT NULL DEFAULT(0),
	MinOrder int NOT NULL DEFAULT(0),
	HotItem  bit NOT  NULL DEFAULT(0),
	ProductDescription nvarchar(500) NULL,
	StatusId int NOT NULL CONSTRAINT Products_Status_fk REFERENCES Status(StatusId)
	
);
GO

GO
--To  keep records of the attributes of the products and their descriptions

CREATE TABLE Attributes
(
	AttributeId int NOT NULL IDENTITY(1,1) CONSTRAINT Attributes_pk PRIMARY KEY,
	AttributeName nvarchar(20) NOT NULL,
	StatusId int NOT NULL CONSTRAINT Attributes_Status_fk REFERENCES Status(StatusId)
);
--To create unique index for Attributes
CREATE UNIQUE INDEX Attributes_AttributeName_ui
ON Attributes(AttributeName);
GO

GO
--TO keep the records of the attribute values

CREATE TABLE AttributeValues
(
	AttributeValueId int NOT NULL IDENTITY(1,1) CONSTRAINT AttributeValues_pk PRIMARY KEY,
	AttributeId int NOT NULL CONSTRAINT AttributeValue_Attributes_fk REFERENCES Attributes(AttributeId),
	AttributeValueName nvarchar(30) NOT NULL,
	StatusId int NOT NULL CONSTRAINT AttributeValues_Status_fk REFERENCES Status(StatusId)
);
--Create unique index for attribute value 
CREATE UNIQUE INDEX AttributeValues_AttributeValueName_ui
ON AttributeValues(AttributeValueName);
GO

GO
--To keep the record about attribute
CREATE TABLE TempAttributes
(
	TempId int NOT NULL IDENTITY(1,1) CONSTRAINT TempAttributes_pk PRIMARY KEY,
	UserSessionId bigint NOT NULL,
	AttributeId int NOT NULL,
	AttributeName nvarchar(50) NOT NULL,
	AttributeValueId int NOT NULL,
	AttributeValue nvarchar(50) NOT NULL
);
GO

GO
--TO keep records of the product Attribute details
CREATE TABLE ProductAttributes
(	
	ProductAttributeId bigint	 NOT NULL IDENTITY(1,1) CONSTRAINT ProductAttributes_pk PRIMARY KEY,
	ProductId bigint NOT NULL CONSTRAINT ProductDetailAttributes__Products_fk REFERENCES Products(ProductId),
	AttributeValueId int NOT NULL CONSTRAINT ProductDetailAttributes__AttributeValues_fk REFERENCES AttributeValues(AttributeValueId),
	StatusId int NOT NULL CONSTRAINT ProductDetailAttributes_Status_fk REFERENCES Status(StatusId)
);
--Crete unique index for productDetailAttributes because product attribute can not be duplicate
CREATE UNIQUE INDEX ProductAttributes_ProductId_AttributeValueId_ui
ON ProductAttributes(ProductId,AttributeValueId);

GO
GO
--To keep the records the image file of the products
CREATE TABLE ProductPhotos
(
	ProductPhotoId  bigint NOT NULL IDENTITY(1,1) CONSTRAINT ProductPhotos_pk PRIMARY KEY,
	ProductId bigint NOT NULL CONSTRAINT ProductPhotos__ProductDetails_fk REFERENCES Products(ProductId),
	ProductPhoto image NOT NULL,
	StatusId int NOT NULL CONSTRAINT ProductPhotos_Status_fk REFERENCES Status(StatusId)
);
GO





GO
--To display the feedbacks from the users 

CREATE TABLE UserFeedbacks
(
	UserFeedbackId int NOT NULL IDENTITy(1,1) CONSTRAINT UserFeedbacks_pk PRIMARY KEY,
	UserId bigint NOT NULL CONSTRAINT UserFeedbacks_Users_fk REFERENCES Users(UserId),
	ProductId Bigint NOT NULL CONSTRAINT UserFeedbacks_ProductDetails_fk REFERENCES Products(ProductId),
	FeedbackMessage nvarchar(700) NOT NULL,
	FeedbackDate Date NOT NULL DEFAULT(GETDATE()),
	StatusId int NOT NULL CONSTRAINT UserFeedbacks_Status_fk REFERENCES Status(StatusId)
	
);
GO

