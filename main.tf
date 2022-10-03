##################################################################################
# AWS Backup Vault
##################################################################################
resource "aws_backup_vault" "backupvault" {
  name = "master_backup_vault"
}

##################################################################################
# AWS Backup Plan 1-Backup Daily and Monthly with varying backup retention periods 
##################################################################################

resource "aws_backup_plan" "dailymonthlybackupplan" {
  name = "daily_backup_plan"

  rule {
    rule_name         = "DailyBackup"
    target_vault_name = aws_backup_vault.backupvault.name
    schedule          = "cron(15 20 * * ? *)"

    lifecycle {
      delete_after = var.daily_backup_retention_days
    }
  }

  rule {
    rule_name         = "MonthlyBackup"
    target_vault_name = aws_backup_vault.backupvault.name
    schedule          = "cron(0 12 1 * ? *)"

    lifecycle {
      delete_after = var.monthly_backup_retention_days
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

##################################################################################
# AWS Backup Resource Selection for plan - 1
##################################################################################

resource "aws_iam_role" "backup_iam_role" {
  name               = "backup_iam_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup_iam_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_iam_role.name
}

resource "aws_backup_selection" "backup_resources" {
  iam_role_arn = aws_iam_role.backup_iam_role.arn
  name         = "DailyMonthlyBackupPlan"
  plan_id      = aws_backup_plan.dailymonthlybackupplan.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Backup"
      value = "daily_monthly"
    }
    string_equals {
      key   = "aws:ResourceTag/Retention_days"
      value = "${var.daily_backup_retention_days}_${var.monthly_backup_retention_days}"
    }

  }
}


##################################################################################
##################################################################################
# AWS Backup Plan 2- Only Backup Daily
##################################################################################
##################################################################################
resource "aws_backup_plan" "onlydailybackupplan" {
  name = "only_daily_backup_plan"

  rule {
    rule_name         = "DailyBackup"
    target_vault_name = aws_backup_vault.backupvault.name
    schedule          = "cron(15 20 * * ? *)"

    lifecycle {
      delete_after = var.only_daily_backup_retention_days
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

##################################################################################
# AWS Backup Resource Selection for plan - 2
##################################################################################

resource "aws_backup_selection" "backup_resources" {
  iam_role_arn = aws_iam_role.backup_iam_role.arn
  name         = "OnlyDailyBackupPlan"
  plan_id      = aws_backup_plan.onlydailybackupplan.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Backup"
      value = "only_daily"
    }
    string_equals {
      key   = "aws:ResourceTag/Retention_days"
      value = var.only_daily_backup_retention_days
    }

  }
}

##################################################################################
# AWS Backup Plan 2- Only Backup Daily
##################################################################################

resource "aws_backup_plan" "onlydailybackupplan" {
  name = "only_daily_backup_plan"

  rule {
    rule_name         = "DailyBackup"
    target_vault_name = aws_backup_vault.backupvault.name
    schedule          = "cron(15 20 * * ? *)"

    lifecycle {
      delete_after = var.only_daily_backup_retention_days
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

##################################################################################
# AWS Backup Plan 2- Only Monthly Backup Daily
##################################################################################

resource "aws_backup_plan" "onlymonthlybackupplan" {
  name = "only_monthly_backup_plan"

  rule {
    rule_name         = "MonthlyBackup"
    target_vault_name = aws_backup_vault.backupvault.name
    schedule          = "cron(15 20 1 * ? *)"

    lifecycle {
      delete_after = var.only_monthly_backup_retention_days
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}



##################################################################################
##################################################################################
# AWS Backup Resource Selection for plan - 3
##################################################################################
##################################################################################
resource "aws_backup_selection" "backup_resources" {
  iam_role_arn = aws_iam_role.backup_iam_role.arn
  name         = "OnlyMonthlyBackupPlan"
  plan_id      = aws_backup_plan.onlymonthlybackupplan.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Backup"
      value = "only_monthly"
    }
    string_equals {
      key   = "aws:ResourceTag/Retention_days"
      value = var.only_monthly_backup_retention_days
    }

  }
}