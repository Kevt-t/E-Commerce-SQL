// Import Sequelize and DataTypes
import { Sequelize, DataTypes } from 'sequelize';

// Import dotenv to load environment variables
import dotenv from 'dotenv';
dotenv.config();

// Create a new Sequelize instance
const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASSWORD, {
  host: process.env.DB_HOST,
  dialect: 'mysql', // Database dialect for MySQL
});

// Define a Product model
const Product = sequelize.define('Product', {
    // Define model attributes
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    price: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
  }, {
    // Model options
    tableName: 'products',
    timestamps: false,
  });

  // Test the connection
try {
    await sequelize.authenticate();
    console.log('Database connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }

  // Sync the Product model
try {
    await Product.sync();
    console.log('Product model was synchronized successfully.');
  } catch (error) {
    console.error('Error synchronizing the Product model:', error);
  }

