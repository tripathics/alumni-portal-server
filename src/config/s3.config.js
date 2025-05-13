import { S3, HeadBucketCommand, CreateBucketCommand } from '@aws-sdk/client-s3';

const { AWS_S3_BUCKET, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION } =
  process.env;

export const s3Client = new S3({
  region: AWS_REGION,
  credentials: {
    accessKeyId: AWS_ACCESS_KEY_ID,
    secretAccessKey: AWS_SECRET_ACCESS_KEY,
  },
});

export const bucketName = AWS_S3_BUCKET;

export const createBucketIfNotExists = async (bucketName) => {
  try {
    await s3Client.send(new HeadBucketCommand({ Bucket: bucketName }));
    console.log(`Bucket "${bucketName}" already exists.`);
  } catch (error) {
    if (error.name === 'NotFound') {
      // Bucket does not exist, create it
      try {
        await s3Client.send(new CreateBucketCommand({ Bucket: bucketName }));
        console.log(`Bucket "${bucketName}" created successfully.`);
      } catch (createError) {
        console.error(`Error creating bucket "${bucketName}":`, createError);
      }
    } else {
      console.error(`Error checking bucket "${bucketName}":`, error);
    }
  }
};
