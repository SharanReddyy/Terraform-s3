resource "aws_s3_bucket" "site" {
  bucket = "staticwbsharan"
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "site" {
  depends_on = [
    aws_s3_bucket_public_access_block.site,
    aws_s3_bucket_ownership_controls.site,
  ]

  bucket = aws_s3_bucket.site.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.site.id
  key    = "index.html"
  source = "./index.html"  # Replace with the actual path to your index.html file
  acl    = "public-read"
  content_type = "text/html"

  # This resource depends on the bucket ACL and ownership controls being applied
  depends_on = [
    aws_s3_bucket_acl.site,
    aws_s3_bucket_ownership_controls.site,
  ]
}

