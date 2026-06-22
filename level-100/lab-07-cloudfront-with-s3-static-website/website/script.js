const facts = [
    "CloudFront delivers content through edge locations worldwide.",
    "Amazon S3 provides highly durable object storage.",
    "CloudFront caches content closer to users for lower latency.",
    "AWS uses IAM to securely control access to resources.",
    "CloudFront supports HTTPS using AWS Certificate Manager."
];

document.getElementById("status").innerText = "Active ✅";

function showFact() {

    const randomIndex = Math.floor(Math.random() * facts.length);

    document.getElementById("fact-box").innerText =
        facts[randomIndex];
}