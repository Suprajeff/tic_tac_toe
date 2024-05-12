package config

import (
    "bufio"
    "log"
    "os"
    "strings"
)

type Environment struct {
    SessionSecret string
    RedisHost     string
}

func GetEnvironment() Environment {
    // Get the current working directory
//	cwd, err := os.Getwd()
//	if err != nil {
//		log.Fatalf("Error getting current working directory: %v", err)
//	}

	// Construct the path to the .env file two levels up
	//envPath := filepath.Join(filepath.Dir(filepath.Dir(cwd)), ".env")

	// Load environment variables from the .env file
	envMap, err := loadEnv(".env")
	if err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}

	sessionSecret, ok := envMap["SESSION_SECRET"]
	if !ok || sessionSecret == "" {
		log.Fatalf("Error: the environment variable SESSION_SECRET is not set")
	}

	redisHost, ok := envMap["REDIS_HOST"]
	if !ok || redisHost == "" {
		log.Fatalf("Error: the environment variable REDIS_HOST is not set")
	}

	return Environment{
		SessionSecret: sessionSecret,
		RedisHost:     redisHost,
	}
}

func loadEnv(envPath string) (map[string]string, error) {
	envMap := make(map[string]string)

	file, err := os.Open(envPath)
	if err != nil {
		return nil, err
	}
	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			
		}
	}(file)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if !strings.HasPrefix(line, "#") && strings.Contains(line, "=") {
			parts := strings.SplitN(line, "=", 2)
			key := strings.TrimSpace(parts[0])
			value := strings.TrimSpace(parts[1])
			envMap[key] = value
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return envMap, nil
}